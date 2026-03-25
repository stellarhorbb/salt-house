# scripts/core/game_manager.gd
# Autoload "GameManager" — global run state, main state machine.
# Responsible for knowing which state the game is in. No game logic here.
extends Node


enum State {
	MAIN_MENU,
	SAVE_SELECT,
	CLASS_SELECT,
	IN_RUN,
	GAME_OVER,
}

var current_state: State = State.MAIN_MENU

# Current run data (reset on each new run)
var current_zone: int = 1
var current_depth: int = 1
var is_run_active: bool = false


func _ready() -> void:
	SignalBus.run_started.connect(_on_run_started)
	SignalBus.run_ended.connect(_on_run_ended)
	SignalBus.depth_completed.connect(_on_depth_completed)
	SignalBus.zone_completed.connect(_on_zone_completed)


func start_run() -> void:
	current_zone = 1
	current_depth = 1
	is_run_active = true
	current_state = State.IN_RUN
	SignalBus.run_started.emit()
	SignalBus.hud_visibility_changed.emit(true)


func end_run(victory: bool) -> void:
	is_run_active = false
	current_state = State.GAME_OVER
	SignalBus.hud_visibility_changed.emit(false)
	SignalBus.run_ended.emit(victory)


# ── Signals ────────────────────────────────────────────────────────────────────

func _on_run_started() -> void:
	pass


func _on_run_ended(_victory: bool) -> void:
	pass


func _on_depth_completed() -> void:
	current_depth += 1


func _on_zone_completed() -> void:
	current_zone += 1
	current_depth = 1
