# scripts/managers/pressure_manager.gd
# Autoload "PressureManager" — sole owner of the current Pressure value.
# Accumulates across the entire combat (hand after hand). Resets between each zone.
extends Node


var pressure: float = GameRules.PRESSURE_BASE


func _ready() -> void:
	SignalBus.run_started.connect(_on_run_started)
	SignalBus.zone_completed.connect(_on_zone_completed)
	SignalBus.player_hit.connect(_on_player_hit)


func reset() -> void:
	pressure = GameRules.PRESSURE_BASE
	SignalBus.pressure_changed.emit(pressure)
	SignalBus.pressure_reset.emit()


func add(amount: float) -> void:
	pressure += amount
	SignalBus.pressure_changed.emit(pressure)


# ── Signals ────────────────────────────────────────────────────────────────────

func _on_run_started() -> void:
	reset()


func _on_zone_completed() -> void:
	reset()


func _on_player_hit() -> void:
	add(GameRules.PRESSURE_PER_HIT)
