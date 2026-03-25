# scripts/managers/entity_manager.gd
# Autoload "EntityManager" — sole owner of the Entity's Salt pool.
# The pool never refills unless an explicit Mutation effect triggers it.
extends Node


const ENTITY := preload("res://resources/entities/entity.tres")
const PROGRESSION := preload("res://resources/entities/entity_progression.tres")

var salt_pool: int = 0
var max_pool: int = 0
var current_zone: ZoneStatsResource = null
var current_zone_number: int = 1


func _ready() -> void:
	SignalBus.run_started.connect(_on_run_started)
	SignalBus.hand_resolved.connect(_on_hand_resolved)


func load_zone(zone_number: int) -> void:
	var stats: ZoneStatsResource = PROGRESSION.get_stats(zone_number)
	if stats == null:
		return
	current_zone_number = zone_number
	current_zone = stats
	salt_pool = stats.salt_pool
	max_pool = stats.salt_pool
	SignalBus.entity_salt_changed.emit(salt_pool)


func steal(amount: int) -> int:
	var stolen := mini(amount, salt_pool)
	salt_pool -= stolen
	SignalBus.entity_salt_changed.emit(salt_pool)
	SignalBus.salt_stolen.emit(stolen)

	if salt_pool <= 0:
		_advance_zone()

	return stolen


func _advance_zone() -> void:
	SignalBus.zone_completed.emit()
	var next_stats: ZoneStatsResource = PROGRESSION.get_stats(current_zone_number + 1)
	if next_stats == null:
		SignalBus.run_ended.emit(true)
		return
	load_zone(current_zone_number + 1)
	SignalBus.zone_changed.emit(current_zone_number)


# ── Signals ────────────────────────────────────────────────────────────────────

func _on_run_started() -> void:
	current_zone_number = 1
	load_zone(1)


func _on_hand_resolved(result: StringName, payout: int) -> void:
	if result == &"win" or result == &"blackjack":
		steal(payout)
