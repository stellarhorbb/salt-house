# scripts/core/scene_manager.gd
# Autoload "SceneManager" — scene transitions.
# Scenes are loaded into the SceneContainer of main.tscn.
# The HUD stays intact — only the content beneath it changes.
extends Node


const SCENES := {
	&"main_menu":    "res://scenes/menus/main_menu.tscn",
	&"save_select":  "res://scenes/menus/save_select.tscn",
	&"class_select": "res://scenes/menus/class_select.tscn",
	&"battle":       "res://scenes/battle/battle_scene.tscn",
	&"shop":         "res://scenes/shop/shop_scene.tscn",
	&"reward":       "res://scenes/reward/reward_scene.tscn",
	&"game_over":    "res://scenes/menus/game_over.tscn",
}

var _scene_container: Node = null
var _current_scene: Node = null


func _ready() -> void:
	SignalBus.scene_change_requested.connect(_on_scene_change_requested)


func init(container: Node) -> void:
	_scene_container = container


func go_to(scene_key: StringName) -> void:
	assert(scene_key in SCENES, "SceneManager: unknown scene key — %s" % scene_key)
	_load_scene(SCENES[scene_key])


func _load_scene(path: String) -> void:
	if _current_scene:
		_current_scene.queue_free()
		_current_scene = null

	var packed: PackedScene = load(path)
	_current_scene = packed.instantiate()
	_scene_container.add_child(_current_scene)


func _on_scene_change_requested(scene_path: String) -> void:
	_load_scene(scene_path)
