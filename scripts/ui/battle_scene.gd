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

# Entity info
@onready var entity_salt_label: Label = $Content/EntityInfo/EntitySaltLabel

# Stake display
@onready var salt_value_label: Label     = $Content/StakeDisplay/SaltColumn/SaltPanel/SaltValueLabel
@onready var pressure_value_label: Label = $Content/StakeDisplay/PressureColumn/PressurePanel/PressureValueLabel

# Preparation layer
@onready var preparation_layer: VBoxContainer = $Content/PreparationLayer
@onready var bet_button_10pct: Button   = $Content/PreparationLayer/BetButtons/BetButton10pct
@onready var bet_button_25pct: Button   = $Content/PreparationLayer/BetButtons/BetButton25pct
@onready var bet_button_50pct: Button   = $Content/PreparationLayer/BetButtons/BetButton50pct
@onready var bet_button_75pct: Button   = $Content/PreparationLayer/BetButtons/BetButton75pct
@onready var bet_button_allin: Button   = $Content/PreparationLayer/BetButtons/BetButtonAllIn
@onready var deal_button: Button        = $Content/PreparationLayer/DealButton

# Play layer
@onready var play_layer: Control             = $Content/PlayLayer
@onready var dealer_hand_container: Control  = $Content/PlayLayer/DealerArea/DealerHandContainer
@onready var dealer_score_label: Label       = $Content/PlayLayer/DealerArea/DealerScoreLabel
@onready var player_hand_container: Control  = $Content/PlayLayer/PlayerArea/PlayerHandContainer
@onready var player_score_label: Label       = $Content/PlayLayer/PlayerArea/PlayerScoreLabel
@onready var result_label: Label             = $Content/PlayLayer/ResultLabel
@onready var hit_button: Button              = $Content/PlayLayer/ActionButtons/HitButton
@onready var stand_button: Button            = $Content/PlayLayer/ActionButtons/StandButton
@onready var double_button: Button           = $Content/PlayLayer/ActionButtons/DoubleButton

# Safe area container
@onready var _content: Control = $Content

# Game over overlay
@onready var game_over_overlay: Control  = $GameOverOverlay
@onready var game_over_title: Label      = $GameOverOverlay/ContentBox/GameOverTitleLabel
@onready var game_over_sub: Label        = $GameOverOverlay/ContentBox/GameOverSubLabel
@onready var restart_button: Button      = $GameOverOverlay/ContentBox/RestartButton

var _current_bet: int = 0
var _is_resolving: bool = false
var _cards_dealt: int = 0          # compteur pour le stagger d'animation
var _hole_card_token: CardVisual = null  # référence au token caché du dealer
var _hole_revealed: bool = false   # true une fois la hole card retournée

# Animation entity salt : gel pendant la main, anime après le résultat
var _hand_active: bool = false
var _entity_salt_displayed: int = 0  # valeur actuellement affichée
var _entity_salt_target: int = 0     # valeur cible (set par entity_salt_changed)


func _ready() -> void:
	_content.offset_left = ui_margin
	_content.offset_right = -ui_margin
	_content.offset_top = ui_margin
	_content.offset_bottom = -ui_margin

	# Init de test si aucun run n'est actif (scène lancée directement)
	if not GameManager.is_run_active:
		GameManager.start_run()
	# Fallback : si lancé directement depuis l'éditeur sans passer par main.tscn
	if SceneManager._scene_container == null:
		SceneManager.init(get_parent(), self)

	# Signaux entrants
	SignalBus.entity_salt_changed.connect(_on_entity_salt_changed)
	SignalBus.pressure_changed.connect(_on_pressure_changed)
	SignalBus.zone_changed.connect(_on_zone_changed)
	SignalBus.hand_started.connect(_on_hand_started)
	SignalBus.player_turn_started.connect(_on_player_turn_started)
	SignalBus.card_drawn.connect(_on_card_drawn)
	SignalBus.dealer_card_drawn.connect(_on_dealer_card_drawn)
	SignalBus.dealer_hole_dealt.connect(_on_dealer_hole_dealt)
	SignalBus.dealer_card_revealed.connect(_on_dealer_card_revealed)
	SignalBus.hand_resolved.connect(_on_hand_resolved)
	SignalBus.run_ended.connect(_on_run_ended)
	restart_button.pressed.connect(_on_restart_pressed)

	# Boutons de mise
	bet_button_10pct.pressed.connect(_on_bet_percent_pressed.bind(0.10))
	bet_button_25pct.pressed.connect(_on_bet_percent_pressed.bind(0.25))
	bet_button_50pct.pressed.connect(_on_bet_percent_pressed.bind(0.50))
	bet_button_75pct.pressed.connect(_on_bet_percent_pressed.bind(0.75))
	bet_button_allin.pressed.connect(_on_bet_percent_pressed.bind(1.0))
	deal_button.pressed.connect(_on_deal_pressed)

	# Boutons de jeu
	hit_button.pressed.connect(_on_hit_pressed)
	stand_button.pressed.connect(_on_stand_pressed)
	double_button.pressed.connect(_on_double_pressed)

	_entity_salt_displayed = EntityManager.salt_pool
	_entity_salt_target = _entity_salt_displayed
	entity_salt_label.text = _fmt(_entity_salt_displayed)
	pressure_value_label.text = "%.1f" % PressureManager.pressure
	_show_preparation()


# ── États ──────────────────────────────────────────────────────────────────────

func _show_preparation() -> void:
	preparation_layer.visible = true
	play_layer.visible = false
	_current_bet = 0
	salt_value_label.text = _fmt(_current_bet)
	_clear_hand(dealer_hand_container)
	_clear_hand(player_hand_container)


func _show_play() -> void:
	preparation_layer.visible = false
	play_layer.visible = true
	dealer_score_label.visible = false
	player_score_label.visible = false


# ── Mise ───────────────────────────────────────────────────────────────────────

func _on_bet_percent_pressed(percent: float) -> void:
	_current_bet = int(BankrollManager.salt * percent)
	salt_value_label.text = _fmt(_current_bet)


func _on_deal_pressed() -> void:
	if _current_bet <= 0 or _is_resolving:
		return
	_show_play()
	await get_tree().process_frame
	BattleManager.start_hand(_current_bet)


# ── Main ───────────────────────────────────────────────────────────────────────

func _on_hit_pressed() -> void:
	_set_action_buttons_enabled(false)
	SignalBus.player_hit.emit()


func _on_stand_pressed() -> void:
	_set_action_buttons_enabled(false)
	SignalBus.player_stood.emit()


func _on_double_pressed() -> void:
	_set_action_buttons_enabled(false)
	SignalBus.player_doubled.emit()


# ── Signaux entrants ───────────────────────────────────────────────────────────

func _on_entity_salt_changed(new_amount: int) -> void:
	_entity_salt_target = new_amount
	if not _hand_active:
		_entity_salt_displayed = new_amount
		entity_salt_label.text = _fmt(new_amount)


func _on_zone_changed(_zone_number: int) -> void:
	_entity_salt_displayed = EntityManager.salt_pool
	_entity_salt_target = _entity_salt_displayed
	entity_salt_label.text = _fmt(_entity_salt_displayed)
	pressure_value_label.text = "%.1f" % PressureManager.pressure
	_show_preparation()


func _on_pressure_changed(new_pressure: float) -> void:
	pressure_value_label.text = "%.1f" % new_pressure


func _on_hand_started() -> void:
	_hand_active = true
	_entity_salt_target = EntityManager.salt_pool  # reset — pas de changement en cours
	_cards_dealt = 0
	_hole_card_token = null
	_hole_revealed = false
	_set_action_buttons_enabled(false)
	_clear_hand(dealer_hand_container)
	_clear_hand(player_hand_container)


func _on_player_turn_started() -> void:
	_set_action_buttons_enabled(true)
	_refresh_double_button()
	player_score_label.visible = true


func _on_card_drawn(card: CardResource) -> void:
	_add_card_to_hand(player_hand_container, card)
	_update_player_score(BattleManager.player_score)


func _on_dealer_card_drawn(card: CardResource) -> void:
	_add_card_to_hand(dealer_hand_container, card)
	if _hole_revealed:
		_update_dealer_score(DealerManager.score)
	else:
		# Deal initial : n'afficher que la valeur de la carte visible
		var visible_value: int = GameRules.ACE_HIGH_VALUE if card.is_ace else card.value
		_update_dealer_score(visible_value)


func _on_dealer_hole_dealt() -> void:
	var token := CardVisualScene.instantiate() as CardVisual
	dealer_hand_container.add_child(token)
	token.setup_hidden(_cards_dealt * 0.12)
	_cards_dealt += 1
	_hole_card_token = token
	_reflow_hand(dealer_hand_container)


func _on_dealer_card_revealed(card: CardResource) -> void:
	_hole_revealed = true
	if _hole_card_token != null:
		_hole_card_token.reveal(card)
	_update_dealer_score(DealerManager.score)


func _on_hand_resolved(result: StringName, payout: int) -> void:
	_hand_active = false
	_is_resolving = true
	_set_action_buttons_enabled(false)
	_show_result(result, payout)

	# Pause dramatique, puis animation des chiffres
	await get_tree().create_timer(0.6).timeout

	if _entity_salt_target != _entity_salt_displayed:
		var from_val := _entity_salt_displayed
		var to_val := _entity_salt_target
		_entity_salt_displayed = to_val

		if to_val < from_val:
			SignalBus.salt_loot_fly.emit(
				entity_salt_label.get_global_rect().get_center(),
				from_val - to_val
			)
			entity_salt_label.modulate = Color(1.0, 0.35, 0.35)
			var tween_col := create_tween()
			tween_col.tween_property(entity_salt_label, "modulate", Color.WHITE, 0.6).set_delay(0.9)

		_punch_label(entity_salt_label, to_val > from_val)
		_count_label(entity_salt_label, from_val, to_val, 1.2)

	await get_tree().create_timer(1.8).timeout
	_is_resolving = false
	result_label.visible = false
	_show_preparation()


func _set_action_buttons_enabled(enabled: bool) -> void:
	hit_button.disabled = not enabled
	stand_button.disabled = not enabled
	double_button.disabled = not enabled


func _refresh_double_button() -> void:
	var is_initial_hand: bool = BattleManager.player_hand.size() == 2
	var can_full_double: bool = BankrollManager.salt >= BattleManager.current_bet
	double_button.text = "DOUBLE" if can_full_double else "ALL IN\nDOUBLE"
	double_button.visible = true
	double_button.disabled = not (is_initial_hand and BankrollManager.salt > 0)


func _show_result(result: StringName, payout: int) -> void:
	result_label.visible = true
	result_label.modulate.a = 0.0
	var tween := create_tween()
	tween.tween_property(result_label, "modulate:a", 1.0, 0.18)
	match result:
		&"win":
			result_label.text = "+ %s" % _fmt(payout)
			result_label.modulate = Color(0.3, 1.0, 0.4)
		&"twenty_one":
			result_label.text = "21  + %s" % _fmt(payout)
			result_label.modulate = Color(0.4, 0.9, 1.0)
		&"blackjack":
			result_label.text = "BLACKJACK  + %s" % _fmt(payout)
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
	game_over_overlay.visible = false
	GameManager.start_run()


# ── Helpers visuels ────────────────────────────────────────────────────────────

func _add_card_to_hand(container: Control, card: CardResource) -> void:
	var token := CardVisualScene.instantiate() as CardVisual
	container.add_child(token)
	token.setup(card, _cards_dealt * 0.12)
	_cards_dealt += 1
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


func _clear_hand(container: Control) -> void:
	for child in container.get_children():
		child.queue_free()
	container.custom_minimum_size = Vector2.ZERO


func _punch_label(label: Label, is_gain: bool) -> void:
	label.pivot_offset = label.size / 2.0
	var tilt := deg_to_rad(7.0) if is_gain else deg_to_rad(-7.0)
	var ts := create_tween()
	ts.tween_property(label, "scale", Vector2(1.4, 1.4), 0.1).set_trans(Tween.TRANS_BACK)
	ts.tween_property(label, "scale", Vector2.ONE, 0.35).set_trans(Tween.TRANS_SPRING)
	var tr := create_tween()
	tr.tween_property(label, "rotation", tilt, 0.1)
	tr.tween_property(label, "rotation", 0.0, 0.35).set_trans(Tween.TRANS_SPRING)


func _count_label(label: Label, from: int, to: int, duration: float) -> void:
	var tween := create_tween()
	tween.tween_method(func(v: float): label.text = _fmt(int(v)), float(from), float(to), duration)


func _update_player_score(score: int) -> void:
	player_score_label.text = str(score)
	player_score_label.modulate = danger_color if score >= danger_score_threshold else normal_color


func _update_dealer_score(score: int) -> void:
	dealer_score_label.visible = true
	dealer_score_label.text = str(score)


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
