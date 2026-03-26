# scripts/ui/reward_scene.gd
# Écran de récompense post-zone — propose 2 choix (PRSR boost ou Salt).
# Un clic = la récompense est appliquée, on avance vers le Shop.
extends Control


@onready var zone_name_label: Label   = $ZoneNameLabel
@onready var zone_number_label: Label = $ZoneNumberLabel
@onready var card1: Button            = $CardsContainer/Card1
@onready var card1_header: Panel      = $CardsContainer/Card1/VBox/Header
@onready var card1_rarity: Label      = $CardsContainer/Card1/VBox/Header/RarityLabel
@onready var card1_value: Label       = $CardsContainer/Card1/VBox/Body/ContentBox/ValueLabel
@onready var card1_type: Label        = $CardsContainer/Card1/VBox/Body/ContentBox/TypeLabel
@onready var card2: Button            = $CardsContainer/Card2
@onready var card2_header: Panel      = $CardsContainer/Card2/VBox/Header
@onready var card2_rarity: Label      = $CardsContainer/Card2/VBox/Header/RarityLabel
@onready var card2_value: Label       = $CardsContainer/Card2/VBox/Body/ContentBox/ValueLabel
@onready var card2_type: Label        = $CardsContainer/Card2/VBox/Body/ContentBox/TypeLabel

var _rewards: Array[RewardResource] = []


func _ready() -> void:
	zone_name_label.text = EntityManager.current_zone.zone_name
	zone_number_label.text = str(EntityManager.current_zone_number)

	# Toujours un choix PRSR et un choix Salt — types garantis différents
	_rewards = [
		RewardResource.generate(&"prsr", _roll_rarity()),
		RewardResource.generate(&"salt", _roll_rarity()),
	]

	_setup_card(card1_header, card1_rarity, card1_value, card1_type, _rewards[0])
	_setup_card(card2_header, card2_rarity, card2_value, card2_type, _rewards[1])

	card1.pressed.connect(_on_card_pressed.bind(0))
	card2.pressed.connect(_on_card_pressed.bind(1))
	card1.mouse_entered.connect(func() -> void: card1.modulate = Color(1.15, 1.15, 1.15))
	card1.mouse_exited.connect(func() -> void: card1.modulate = Color.WHITE)
	card2.mouse_entered.connect(func() -> void: card2.modulate = Color(1.15, 1.15, 1.15))
	card2.mouse_exited.connect(func() -> void: card2.modulate = Color.WHITE)


func _setup_card(header: Panel, rarity_label: Label, value_label: Label, type_label: Label, reward: RewardResource) -> void:
	var style := StyleBoxFlat.new()
	style.bg_color = reward.get_rarity_color()
	header.add_theme_stylebox_override("panel", style)
	rarity_label.text = String(reward.rarity).to_upper()
	value_label.text = reward.get_display_value()
	type_label.text = reward.get_type_label()


func _roll_rarity() -> StringName:
	var roll := randi() % 100
	if roll < 5:
		return &"legendary"
	elif roll < 20:
		return &"rare"
	elif roll < 50:
		return &"uncommon"
	return &"common"


func _on_card_pressed(index: int) -> void:
	var reward: RewardResource = _rewards[index]
	match reward.type:
		&"prsr":
			PressureManager.add(reward.value)
		&"salt":
			BankrollManager.add(int(BankrollManager.salt * reward.value))
	SceneManager.go_to(&"shop")
