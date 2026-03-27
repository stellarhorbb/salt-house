# scripts/ui/hud.gd
# HUD persistant — affiché pendant tout le run, jamais swappé.
# Reçoit exclusivement des signaux, ne touche pas aux managers directement
# sauf pour l'initialisation au _ready.
extends Control


const CardVisualScene := preload("res://scenes/battle/hand/card_visual.tscn")
const CARD_ORDER := ["A", "2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K"]

@onready var zone_name_label: Label   = $TopLeft/ZoneNameLabel
@onready var zone_number_label: Label = $TopLeft/ZoneNumberLabel
@onready var turn_value_label: Label  = $TopRight/TurnValueLabel

@onready var salt_label: Label        = $BottomLeft/SaltRow/SaltLabel
@onready var shells_label: Label      = $BottomLeft/ShellsRow/ShellsLabel

@onready var deck_node: HBoxContainer  = $Deck
@onready var deck_count_label: Label   = $Deck/DeckCountLabel
@onready var salt_icon_node: TextureRect = $BottomLeft/SaltRow/SaltIcon

@onready var moon_last_quarter_label: Label  = $MoonCardPanel/MoonRow_LastQuarter/ValueLabel
@onready var moon_full_moon_label: Label     = $MoonCardPanel/MoonRow_FullMoon/ValueLabel
@onready var moon_first_quarter_label: Label = $MoonCardPanel/MoonRow_FirstQuarter/ValueLabel
@onready var moon_new_moon_label: Label      = $MoonCardPanel/MoonRow_NewMoon/ValueLabel

@onready var deck_inspector: Control        = $DeckInspector
@onready var close_button: Button           = $DeckInspector/Content/Header/CloseButton
@onready var row_diamonds: HBoxContainer    = $DeckInspector/Content/RowDiamonds
@onready var row_hearts: HBoxContainer      = $DeckInspector/Content/RowHearts
@onready var row_spades: HBoxContainer      = $DeckInspector/Content/RowSpades
@onready var row_clubs: HBoxContainer       = $DeckInspector/Content/RowClubs

var _turn_count: int = 0
var _salt_displayed: int = 0
var _salt_tween: Tween = null


func _ready() -> void:
	SignalBus.run_started.connect(_on_run_started)
	SignalBus.salt_changed.connect(_on_salt_changed)
	SignalBus.gold_shells_changed.connect(_on_shells_changed)
	SignalBus.zone_changed.connect(_on_zone_changed)
	SignalBus.hand_resolved.connect(_on_hand_resolved)
	SignalBus.card_drawn.connect(_on_any_card_drawn)
	SignalBus.dealer_card_drawn.connect(_on_any_card_drawn)
	SignalBus.dealer_hole_dealt.connect(_on_any_card_drawn)
	SignalBus.moon_card_applied.connect(_on_moon_card_applied)
	SignalBus.salt_loot_fly.connect(_on_salt_loot_fly)

	deck_node.gui_input.connect(_on_deck_gui_input)
	close_button.pressed.connect(_close_deck_inspector)
	set_process_unhandled_key_input(true)


func _refresh_zone() -> void:
	if EntityManager.current_zone == null:
		return
	zone_name_label.text = EntityManager.current_zone.zone_name
	zone_number_label.text = str(EntityManager.current_zone_number)


func _refresh_moon_display() -> void:
	var b: float = MoonCardManager.pressure_base_bonus
	moon_first_quarter_label.text = "+%.2f" % b if b > 0.0 else "—"
	var h: float = MoonCardManager.pressure_per_hit_bonus
	moon_last_quarter_label.text = "+%.2f" % h if h > 0.0 else "—"
	var s: float = MoonCardManager.salt_steal_bonus_pct
	moon_full_moon_label.text = "+%d%%" % int(s * 100.0) if s > 0.0 else "—"
	var r: float = MoonCardManager.salt_recovery_pct
	moon_new_moon_label.text = "+%d%%" % int(r * 100.0) if r > 0.0 else "—"


# ── Deck Inspector ──────────────────────────────────────────────────────────────

func _unhandled_key_input(event: InputEvent) -> void:
	if event is InputEventKey and event.keycode == KEY_TAB:
		if event.pressed and not event.echo:
			_open_deck_inspector()
		elif not event.pressed:
			_close_deck_inspector()


func _on_deck_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton \
			and event.pressed \
			and event.button_index == MOUSE_BUTTON_LEFT:
		_open_deck_inspector()


func _open_deck_inspector() -> void:
	_populate_inspector()
	deck_inspector.visible = true


func _close_deck_inspector() -> void:
	deck_inspector.visible = false


func _populate_inspector() -> void:
	var draw_pile: Array[CardResource] = DeckManager.get_draw_pile()
	_fill_row(row_diamonds, CardResource.FAMILY_DIAMONDS, draw_pile)
	_fill_row(row_hearts,   CardResource.FAMILY_HEARTS,   draw_pile)
	_fill_row(row_spades,   CardResource.FAMILY_SPADES,   draw_pile)
	_fill_row(row_clubs,    CardResource.FAMILY_CLUBS,    draw_pile)


func _fill_row(row: HBoxContainer, family: StringName, all: Array[CardResource]) -> void:
	for child in row.get_children():
		child.queue_free()

	var family_cards: Array[CardResource] = []
	for card: CardResource in all:
		if card.family == family:
			family_cards.append(card)

	family_cards.sort_custom(func(a: CardResource, b: CardResource) -> bool:
		return CARD_ORDER.find(a.display_name) < CARD_ORDER.find(b.display_name)
	)

	for i: int in family_cards.size():
		var cv: CardVisual = CardVisualScene.instantiate()
		row.add_child(cv)
		cv.setup(family_cards[i], i * 0.04)


# ── Signaux entrants ───────────────────────────────────────────────────────────

func _on_run_started() -> void:
	_turn_count = 0
	_salt_displayed = BankrollManager.salt
	turn_value_label.text = "0"
	salt_label.text = _fmt(_salt_displayed)
	shells_label.text = str(GoldShellManager.gold_shells)
	deck_count_label.text = str(DeckManager.remaining())
	_refresh_zone()
	_refresh_moon_display()


func _on_salt_changed(new_amount: int) -> void:
	var from: int = _salt_displayed
	_salt_displayed = new_amount
	if from == new_amount:
		return
	if _salt_tween:
		_salt_tween.kill()
	var is_gain: bool = new_amount > from
	var flash: Color = Color(0.3, 1.0, 0.45) if is_gain else Color(1.0, 0.35, 0.35)
	_punch_label(salt_label, is_gain)
	salt_label.modulate = flash
	_salt_tween = create_tween()
	_salt_tween.tween_method(func(v: float): salt_label.text = _fmt(int(v)), float(from), float(new_amount), 0.7)
	_salt_tween.parallel().tween_property(salt_label, "modulate", Color.WHITE, 0.5)


func _on_shells_changed(new_amount: int) -> void:
	shells_label.text = str(new_amount)


func _on_zone_changed(_zone_number: int) -> void:
	_turn_count = 0
	turn_value_label.text = "0"
	shells_label.text = str(GoldShellManager.gold_shells)
	deck_count_label.text = str(DeckManager.remaining())
	_refresh_zone()
	_refresh_moon_display()


func _on_hand_resolved(_result: StringName, _payout: int) -> void:
	_turn_count += 1
	turn_value_label.text = str(_turn_count)


func _on_any_card_drawn(_arg = null) -> void:
	deck_count_label.text = str(DeckManager.remaining())


func _on_moon_card_applied(_card: MoonCardResource) -> void:
	_refresh_moon_display()


func _on_salt_loot_fly(from_screen: Vector2, _amount: int) -> void:
	var count: int = 20
	var to: Vector2 = salt_label.get_global_rect().get_center()
	var mid: Vector2 = lerp(from_screen, to, 0.5)
	for i: int in count:
		var icon := Sprite2D.new()
		icon.texture = salt_icon_node.texture
		icon.scale = salt_icon_node.size / icon.texture.get_size()
		add_child(icon)
		icon.position = from_screen

		var ctrl1: Vector2 = lerp(from_screen, mid, 0.4) + Vector2(randf_range(-300, 300), randf_range(-400, -100))
		var ctrl2: Vector2 = lerp(mid, to, 0.6) + Vector2(randf_range(-200, 200), randf_range(-200, 100))
		var delay: float = i * 0.06
		var duration: float = 1.1 + randf_range(-0.15, 0.3)

		var tween := create_tween()
		tween.tween_method(
			func(t: float) -> void:
				icon.position = _bezier_cubic(t, from_screen, ctrl1, ctrl2, to),
			0.0, 1.0, duration
		).set_delay(delay).set_trans(Tween.TRANS_SINE)
		tween.tween_property(icon, "modulate:a", 0.0, 0.2)
		tween.tween_callback(icon.queue_free)


# ── Helpers ────────────────────────────────────────────────────────────────────

func _punch_label(label: Label, is_gain: bool) -> void:
	label.pivot_offset = label.size / 2.0
	var tilt: float = deg_to_rad(7.0) if is_gain else deg_to_rad(-7.0)
	var ts := create_tween()
	ts.tween_property(label, "scale", Vector2(1.4, 1.4), 0.1).set_trans(Tween.TRANS_BACK)
	ts.tween_property(label, "scale", Vector2.ONE, 0.35).set_trans(Tween.TRANS_SPRING)
	var tr := create_tween()
	tr.tween_property(label, "rotation", tilt, 0.1)
	tr.tween_property(label, "rotation", 0.0, 0.35).set_trans(Tween.TRANS_SPRING)


func _bezier(t: float, p0: Vector2, p1: Vector2, p2: Vector2) -> Vector2:
	return (1.0 - t) * (1.0 - t) * p0 + 2.0 * (1.0 - t) * t * p1 + t * t * p2


func _bezier_cubic(t: float, p0: Vector2, p1: Vector2, p2: Vector2, p3: Vector2) -> Vector2:
	var u: float = 1.0 - t
	return u*u*u * p0 + 3.0*u*u*t * p1 + 3.0*u*t*t * p2 + t*t*t * p3


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
