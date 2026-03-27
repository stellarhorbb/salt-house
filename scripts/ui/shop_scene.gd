# scripts/ui/shop_scene.gd
# Shop entre les zones — affiche un Moon Pack à acheter, reroll, puis choix de carte.
extends Control


const BLOOD_MOON_SAMPLE_SIZE := 8
const CardVisualScene := preload("res://scenes/battle/hand/card_visual.tscn")

@onready var reroll_button: Button     = $Center/RerollButton
@onready var reroll_cost_label: Label  = $Center/RerollButton/RerollCostLabel

# Pack fermé
@onready var pack_layer: Control       = $Center/PackLayer
@onready var buy_button: Button        = $Center/PackLayer/BuyButton
@onready var buy_price_label: Label    = $Center/PackLayer/BuyButton/BuyPriceLabel

# Pack ouvert
@onready var cards_layer: Control      = $Center/CardsLayer
@onready var card1_button: Button      = $Center/CardsLayer/CardsRow/Card1Button
@onready var card1_image: TextureRect  = $Center/CardsLayer/CardsRow/Card1Button/CardImage
@onready var card2_button: Button      = $Center/CardsLayer/CardsRow/Card2Button
@onready var card2_image: TextureRect  = $Center/CardsLayer/CardsRow/Card2Button/CardImage

# Blood Moon — suppression de carte
@onready var card_removal_layer: Control       = $CardRemovalLayer
@onready var removal_cards_row: HBoxContainer  = $CardRemovalLayer/RemovalCardsRow


func _ready() -> void:
	SignalBus.shop_rerolled.connect(_refresh_pack_state)
	SignalBus.blood_moon_triggered.connect(_show_card_removal)

	reroll_button.pressed.connect(_on_reroll_pressed)
	buy_button.pressed.connect(_on_buy_pressed)
	card1_button.pressed.connect(_on_card_chosen.bind(0))
	card2_button.pressed.connect(_on_card_chosen.bind(1))

	_refresh_pack_state()
	_show_pack_closed()


# ── États ──────────────────────────────────────────────────────────────────────

func _show_pack_closed() -> void:
	pack_layer.visible = true
	cards_layer.visible = false
	card_removal_layer.visible = false
	reroll_button.visible = true


func _show_pack_open() -> void:
	pack_layer.visible = false
	cards_layer.visible = true
	card_removal_layer.visible = false
	reroll_button.visible = false
	var cards := ShopManager.pack_cards
	card1_image.texture = cards[0].icon
	card2_image.texture = cards[1].icon


func _show_card_removal() -> void:
	pack_layer.visible = false
	cards_layer.visible = false
	card_removal_layer.visible = true
	reroll_button.visible = false

	# Vider les cartes précédentes
	for child in removal_cards_row.get_children():
		child.queue_free()

	var selection: Array[CardResource] = DeckManager.get_sample(BLOOD_MOON_SAMPLE_SIZE)
	for card: CardResource in selection:
		var cv: CardVisual = CardVisualScene.instantiate()
		removal_cards_row.add_child(cv)
		cv.setup(card)
		cv.get_node("Panel").mouse_filter = Control.MOUSE_FILTER_PASS
		cv.gui_input.connect(func(event: InputEvent) -> void:
			if event is InputEventMouseButton \
					and event.pressed \
					and event.button_index == MOUSE_BUTTON_LEFT:
				_on_removal_card_pressed(card)
		)


# ── Rafraîchissement ───────────────────────────────────────────────────────────

func _refresh_pack_state() -> void:
	reroll_button.disabled = not ShopManager.can_reroll()
	buy_button.disabled = not ShopManager.can_buy_pack()
	reroll_cost_label.text = str(ShopManager.get_reroll_cost())
	buy_price_label.text = str(GameRules.SHOP_MOON_PACK_PRICE)


# ── Actions ────────────────────────────────────────────────────────────────────

func _on_reroll_pressed() -> void:
	ShopManager.reroll()


func _on_buy_pressed() -> void:
	ShopManager.buy_pack()
	_show_pack_open()


func _on_card_chosen(index: int) -> void:
	var card: MoonCardResource = ShopManager.pack_cards[index]
	MoonCardManager.apply(card)
	if card.effect_type != MoonCardResource.EffectType.BLOOD_MOON:
		EntityManager.proceed_to_next_zone()


func _on_removal_card_pressed(card: CardResource) -> void:
	DeckManager.remove_from_pool(card)
	EntityManager.proceed_to_next_zone()
