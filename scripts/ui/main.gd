# scripts/ui/main.gd
# Root script for main.tscn — initializes SceneManager and loads the main menu.
# This scene never changes: it is the permanent container of the game.
extends Node


@onready var scene_container: Control = $SceneLayer/SceneContainer
@onready var hud: Control = $HUDLayer/HUD


func _ready() -> void:
	SceneManager.init(scene_container)
	SignalBus.hud_visibility_changed.connect(_on_hud_visibility_changed)
	SceneManager.go_to(&"main_menu")


func _on_hud_visibility_changed(is_visible: bool) -> void:
	hud.visible = is_visible
