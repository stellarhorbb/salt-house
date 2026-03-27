# scripts/ui/shop_scene.gd
# Shop entre les zones — affiche un Moon Pack à acheter, reroll, puis choix de carte.
extends Control


@onready var zone_name_label: Label    = $TopLeft/ZoneNameLabel
@onready var zone_number_label: Label  = $TopLeft/ZoneNumberLabel
@onready var turn_label: Label         = $TopRight/TurnLabel

@onready var shells_label: Label       = $BottomLeft/ShellsRow/ShellsLabel
@onready var salt_label: Label         = $BottomLeft/SaltRow/SaltLabel

@onready var reroll_button: Button     = $Center/RerollButton
@onready var reroll_cost_label: Label  = $Center/RerollButton/RerollCostLabel

# Pack fermé
@onready var pack_layer: Control       = $Center/PackLayer
@onready var pack_image: TextureRect   = $Center/PackLayer/PackImage
@onready var buy_button: Button        = $Center/PackLayer/BuyButton
@onready var buy_price_label: Label    = $Center/PackLayer/BuyButton/BuyPriceLabel

# Pack ouvert
@onready var cards_layer: Control      = $Center/CardsLayer
@onready var card1_button: Button      = $Center/CardsLayer/Card1Button
@onready var card1_image: TextureRect  = $Center/CardsLayer/Card1Button/CardImage
@onready var card2_button: Button      = $Center/CardsLayer/Card2Button
@onready var card2_image: TextureRect  = $Center/CardsLayer/Card2Button/CardImage
@onready var choose_label: Label       = $Center/CardsLayer/ChooseLabel

# Moon Card panel (droite)
@onready var moon_last_quarter_label: Label  = $MoonCardPanel/MoonRow_LastQuarter/ValueLabel
@onready var moon_full_moon_label: Label     = $MoonCardPanel/MoonRow_FullMoon/ValueLabel
@onready var moon_first_quarter_label: Label = $MoonCardPanel/MoonRow_FirstQuarter/ValueLabel
@onready var moon_new_moon_label: Label      = $MoonCardPanel/MoonRow_NewMoon/ValueLabel


func _ready() -> void:
	zone_name_label.text = EntityManager.current_zone.zone_name
	zone_number_label.text = str(EntityManager.current_zone_number)
	turn_label.text = "0"

	SignalBus.gold_shells_changed.connect(_on_shells_changed)
	SignalBus.salt_changed.connect(_on_salt_changed)
	SignalBus.shop_rerolled.connect(_refresh_pack_state)

	reroll_button.pressed.connect(_on_reroll_pressed)
	buy_button.pressed.connect(_on_buy_pressed)
	card1_button.pressed.connect(_on_card_chosen.bind(0))
	card2_button.pressed.connect(_on_card_chosen.bind(1))

	_refresh_balances()
	_refresh_pack_state()
	_refresh_moon_display()
	_show_pack_closed()


# ── États ──────────────────────────────────────────────────────────────────────

func _show_pack_closed() -> void:
	pack_layer.visible = true
	cards_layer.visible = false
	reroll_button.visible = true


func _show_pack_open() -> void:
	pack_layer.visible = false
	cards_layer.visible = true
	reroll_button.visible = false
	var cards := ShopManager.pack_cards
	card1_image.texture = cards[0].icon
	card2_image.texture = cards[1].icon


# ── Rafraîchissement ───────────────────────────────────────────────────────────

func _refresh_pack_state() -> void:
	reroll_button.disabled = not ShopManager.can_reroll()
	buy_button.disabled = not ShopManager.can_buy_pack()
	reroll_cost_label.text = str(ShopManager.get_reroll_cost())
	buy_price_label.text = str(GameRules.SHOP_MOON_PACK_PRICE)


func _refresh_balances() -> void:
	shells_label.text = str(GoldShellManager.gold_shells)
	salt_label.text = _fmt(BankrollManager.salt)


func _refresh_moon_display() -> void:
	var b: float = MoonCardManager.pressure_base_bonus
	moon_first_quarter_label.text = "+%.2f" % b if b > 0.0 else "—"
	var h: float = MoonCardManager.pressure_per_hit_bonus
	moon_last_quarter_label.text = "+%.2f" % h if h > 0.0 else "—"
	var s: float = MoonCardManager.salt_steal_bonus_pct
	moon_full_moon_label.text = "+%d%%" % int(s * 100.0) if s > 0.0 else "—"
	var r: float = MoonCardManager.salt_recovery_pct
	moon_new_moon_label.text = "+%d%%" % int(r * 100.0) if r > 0.0 else "—"


# ── Actions ────────────────────────────────────────────────────────────────────

func _on_reroll_pressed() -> void:
	ShopManager.reroll()
	_refresh_balances()


func _on_buy_pressed() -> void:
	ShopManager.buy_pack()
	_refresh_balances()
	_show_pack_open()


func _on_card_chosen(index: int) -> void:
	MoonCardManager.apply(ShopManager.pack_cards[index])
	_refresh_moon_display()
	EntityManager.proceed_to_next_zone()


# ── Signaux entrants ───────────────────────────────────────────────────────────

func _on_shells_changed(_amount: int) -> void:
	_refresh_balances()
	_refresh_pack_state()


func _on_salt_changed(new_amount: int) -> void:
	salt_label.text = _fmt(new_amount)


# ── Helpers ────────────────────────────────────────────────────────────────────

func _fmt(n: int) -> String:
	var s := str(n)
	var result := ""
	var count := 0
	for i: int in range(s.length() - 1, -1, -1):
		if count > 0 and count % 3 == 0:
			result = "," + result
		result = s[i] + result
		count += 1
	return result
