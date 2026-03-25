# scripts/ui/hud.gd
# Persistent HUD — displayed for the entire duration of a run, never swapped out.
# Updates exclusively via SignalBus signals.
extends Control


@export var pressure_high_color: Color = Color(1.0, 0.8, 0.0)
@export var normal_color: Color = Color(1.0, 1.0, 1.0)
@export var low_salt_color: Color = Color(1.0, 0.3, 0.3)

@onready var salt_value: Label = $TopBar/SaltDisplay/SaltValue
@onready var pressure_value: Label = $TopBar/PressureDisplay/PressureValue
@onready var depth_value: Label = $TopBar/DepthDisplay/DepthValue


func _ready() -> void:
	SignalBus.salt_changed.connect(_on_salt_changed)
	SignalBus.pressure_changed.connect(_on_pressure_changed)
	SignalBus.depth_completed.connect(_refresh_depth)
	SignalBus.zone_completed.connect(_refresh_depth)


func _on_salt_changed(new_amount: int) -> void:
	salt_value.text = str(new_amount)


func _on_pressure_changed(new_pressure: float) -> void:
	pressure_value.text = "%.2f" % new_pressure
	pressure_value.modulate = pressure_high_color if new_pressure >= 2.0 else normal_color


func _refresh_depth() -> void:
	depth_value.text = "%d-%d" % [GameManager.current_zone, GameManager.current_depth]
