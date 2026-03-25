# scripts/ui/battle_scene.gd
# Contrôle la scène de combat — deux états : préparation (mise) et jeu (hit/stand).
# Ne contient aucune logique de jeu : émet des signaux et réagit au SignalBus.
extends Control


const CardVisualScene := preload("res://scenes/battle/hand/card_visual.tscn")

# Chevauchement des jetons dans la main
@export var ui_margin: int = 20
@export var card_overlap: int = 40
# Seuil de score pour colorer le score en rouge (proche du bust)
@export var danger_score_threshold: int = 18
@export var danger_color: Color = Color(1.0, 0.3, 0.3)
@export var normal_color: Color = Color(1.0, 1.0, 1.0)

# Top bar
@onready var zone_name_label: Label           = $Content/TopBar/ZoneInfo/ZoneNameLabel
@onready var depth_label: Label               = $Content/TopBar/ZoneInfo/DepthLabel
@onready var turn_counter_label: Label        = $Content/TopBar/EntityBarContainer/EntityBarRow/TurnCounterLabel
@onready var entity_salt_label: Label         = $Content/TopBar/EntityBarContainer/EntityBarRow/EntitySaltLabel
@onready var entity_progress_bar: ProgressBar = $Content/TopBar/EntityBarContainer/EntityProgressBar
@onready var salt_amount_label: Label         = $Content/TopBar/SaltInfo/SaltAmountLabel

# Stake display
@onready var salt_value_label: Label     = $Content/StakeDisplay/SaltColumn/SaltPanel/SaltValueLabel
@onready var pressure_value_label: Label = $Content/StakeDisplay/PressureColumn/PressurePanel/PressureValueLabel

# Preparation layer
@onready var preparation_layer: VBoxContainer = $Content/PreparationLayer
@onready var bet_button_10: Button   = $Content/PreparationLayer/BetButtons/BetButton10
@onready var bet_button_20: Button   = $Content/PreparationLayer/BetButtons/BetButton20
@onready var bet_button_50: Button   = $Content/PreparationLayer/BetButtons/BetButton50
@onready var bet_button_100: Button  = $Content/PreparationLayer/BetButtons/BetButton100
@onready var deal_button: Button     = $Content/PreparationLayer/DealButton

# Play layer
@onready var play_layer: Control             = $Content/PlayLayer
@onready var dealer_hand_container: Control  = $Content/PlayLayer/DealerArea/DealerHandContainer
@onready var dealer_score_label: Label       = $Content/PlayLayer/DealerArea/DealerScoreLabel
@onready var player_hand_container: Control  = $Content/PlayLayer/PlayerArea/PlayerHandContainer
@onready var player_score_label: Label       = $Content/PlayLayer/PlayerArea/PlayerScoreLabel
@onready var result_label: Label             = $Content/PlayLayer/ResultLabel
@onready var hit_button: Button              = $Content/PlayLayer/ActionButtons/HitButton
@onready var stand_button: Button            = $Content/PlayLayer/ActionButtons/StandButton

# Safe area container
@onready var _content: Control = $Content

# Game over overlay
@onready var game_over_overlay: Control  = $GameOverOverlay
@onready var game_over_title: Label      = $GameOverOverlay/ContentBox/GameOverTitleLabel
@onready var game_over_sub: Label        = $GameOverOverlay/ContentBox/GameOverSubLabel
@onready var restart_button: Button      = $GameOverOverlay/ContentBox/RestartButton

var _current_bet: int = 0
var _turn_count: int = 0


func _ready() -> void:
	_content.offset_left = ui_margin
	_content.offset_right = -ui_margin
	_content.offset_top = ui_margin
	_content.offset_bottom = -ui_margin

	# Init de test si aucun run n'est actif (scène lancée directement)
	if not GameManager.is_run_active:
		GameManager.start_run()

	# Signaux entrants
	SignalBus.salt_changed.connect(_on_salt_changed)
	SignalBus.entity_salt_changed.connect(_on_entity_salt_changed)
	SignalBus.pressure_changed.connect(_on_pressure_changed)
	SignalBus.zone_changed.connect(_on_zone_changed)
	SignalBus.hand_started.connect(_on_hand_started)
	SignalBus.card_drawn.connect(_on_card_drawn)
	SignalBus.dealer_card_drawn.connect(_on_dealer_card_drawn)
	SignalBus.hand_resolved.connect(_on_hand_resolved)
	SignalBus.run_ended.connect(_on_run_ended)
	restart_button.pressed.connect(_on_restart_pressed)

	# Boutons de mise
	bet_button_10.pressed.connect(_on_bet_button_pressed.bind(10))
	bet_button_20.pressed.connect(_on_bet_button_pressed.bind(20))
	bet_button_50.pressed.connect(_on_bet_button_pressed.bind(50))
	bet_button_100.pressed.connect(_on_bet_button_pressed.bind(100))
	deal_button.pressed.connect(_on_deal_pressed)

	# Boutons de jeu
	hit_button.pressed.connect(_on_hit_pressed)
	stand_button.pressed.connect(_on_stand_pressed)

	_refresh_zone_labels()
	_show_preparation()


# ── États ──────────────────────────────────────────────────────────────────────

func _refresh_zone_labels() -> void:
	if EntityManager.current_zone == null:
		return
	zone_name_label.text = EntityManager.current_zone.zone_name
	depth_label.text = str(EntityManager.current_zone_number)


# ── États ──────────────────────────────────────────────────────────────────────

func _show_preparation() -> void:
	preparation_layer.visible = true
	play_layer.visible = false
	_current_bet = 0
	_refresh_top_bar()
	_clear_hand(dealer_hand_container)
	_clear_hand(player_hand_container)


func _show_play() -> void:
	preparation_layer.visible = false
	play_layer.visible = true
	dealer_score_label.text = "0"
	player_score_label.text = "0"


# ── Mise ───────────────────────────────────────────────────────────────────────

func _on_bet_button_pressed(amount: int) -> void:
	if not BankrollManager.can_afford(_current_bet + amount):
		return
	_current_bet += amount
	_refresh_top_bar()


func _refresh_top_bar() -> void:
	salt_value_label.text = str(_current_bet)
	entity_salt_label.text = str(EntityManager.salt_pool)
	entity_progress_bar.value = float(EntityManager.salt_pool) / float(maxi(EntityManager.max_pool, 1)) * 100.0
	turn_counter_label.text = "Turn " + str(_turn_count)


func _on_deal_pressed() -> void:
	if _current_bet <= 0:
		return
	_show_play()
	await get_tree().process_frame
	BattleManager.start_hand(_current_bet)


# ── Main ───────────────────────────────────────────────────────────────────────

func _on_hit_pressed() -> void:
	SignalBus.player_hit.emit()


func _on_stand_pressed() -> void:
	SignalBus.player_stood.emit()


# ── Signaux entrants ───────────────────────────────────────────────────────────

func _on_salt_changed(new_amount: int) -> void:
	salt_amount_label.text = str(new_amount)


func _on_entity_salt_changed(_new_amount: int) -> void:
	_refresh_top_bar()


func _on_zone_changed(_zone_number: int) -> void:
	_turn_count = 0
	_refresh_zone_labels()
	_refresh_top_bar()
	_show_preparation()


func _on_pressure_changed(new_pressure: float) -> void:
	pressure_value_label.text = "%.2f" % new_pressure


func _on_hand_started() -> void:
	_clear_hand(dealer_hand_container)
	_clear_hand(player_hand_container)


func _on_card_drawn(card: CardResource) -> void:
	_add_card_to_hand(player_hand_container, card)
	_update_player_score(BattleManager.player_score)


func _on_dealer_card_drawn(card: CardResource) -> void:
	_add_card_to_hand(dealer_hand_container, card)
	_update_dealer_score(DealerManager.score)


func _on_hand_resolved(result: StringName, payout: int) -> void:
	_turn_count += 1
	hit_button.disabled = true
	stand_button.disabled = true
	_show_result(result, payout)
	await get_tree().create_timer(2.0).timeout
	result_label.visible = false
	hit_button.disabled = false
	stand_button.disabled = false
	_show_preparation()


func _show_result(result: StringName, payout: int) -> void:
	result_label.visible = true
	match result:
		&"win":
			result_label.text = "+ %d" % payout
			result_label.modulate = Color(0.3, 1.0, 0.4)
		&"blackjack":
			result_label.text = "BLACKJACK  + %d" % payout
			result_label.modulate = Color(1.0, 0.85, 0.0)
		&"bust":
			result_label.text = "BUST"
			result_label.modulate = danger_color
		&"lose":
			result_label.text = "LOSE"
			result_label.modulate = danger_color
		&"push":
			result_label.text = "PUSH"
			result_label.modulate = normal_color


func _on_run_ended(victory: bool) -> void:
	game_over_overlay.visible = true
	if victory:
		game_over_title.text = "VICTORY"
		game_over_sub.text = "Entity defeated"
	else:
		game_over_title.text = "GAME OVER"
		game_over_sub.text = "You ran out of Salt"


func _on_restart_pressed() -> void:
	_turn_count = 0
	game_over_overlay.visible = false
	GameManager.start_run()


# ── Helpers visuels ────────────────────────────────────────────────────────────

func _add_card_to_hand(container: Control, card: CardResource) -> void:
	var token := CardVisualScene.instantiate()
	container.add_child(token)
	token.setup(card)
	_reflow_hand(container)


func _reflow_hand(container: Control) -> void:
	var count := container.get_child_count()
	var token_width := 110
	var step := token_width - card_overlap
	var total_width: float = (count - 1) * step + token_width
	var offset_x: float = (container.size.x - total_width) * 0.5

	for i in count:
		var child: Control = container.get_child(i)
		child.position.x = offset_x + i * step
		child.position.y = 0

	container.custom_minimum_size.x = total_width


func _add_hidden_card_to_dealer() -> void:
	# Jeton gris avec "?" pour la carte cachée du dealer
	var token := CardVisualScene.instantiate()
	dealer_hand_container.add_child(token)

	var hidden_card := CardResource.new()
	hidden_card.family = &"spades"
	hidden_card.value = 0
	hidden_card.display_name = "?"
	token.setup(hidden_card)

	var index := dealer_hand_container.get_child_count() - 1
	token.position.x = index * (110 - card_overlap)
	dealer_hand_container.custom_minimum_size.x = index * (110 - card_overlap) + 110


func _reveal_dealer_hidden_card() -> void:
	# À implémenter quand le dealer joue son tour
	pass


func _clear_hand(container: Control) -> void:
	for child in container.get_children():
		child.queue_free()
	container.custom_minimum_size = Vector2.ZERO


func _update_player_score(score: int) -> void:
	player_score_label.text = str(score)
	player_score_label.modulate = danger_color if score >= danger_score_threshold else normal_color


func _update_dealer_score(score: int) -> void:
	dealer_score_label.text = str(score)
