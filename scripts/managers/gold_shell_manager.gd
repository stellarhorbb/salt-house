# scripts/managers/gold_shell_manager.gd
# Autoload "GoldShellManager" — sole owner of the player's Gold Shells.
# Gold Shells are earned post-combat and spent exclusively at the Shop.
# They never interact with Salt — completely separate resource.
extends Node


var gold_shells: int = 0
var _hands_this_zone: int = 0


func _ready() -> void:
	SignalBus.run_started.connect(_on_run_started)
	SignalBus.hand_resolved.connect(_on_hand_resolved)
	SignalBus.zone_completed.connect(_on_zone_completed)
	SignalBus.zone_changed.connect(_on_zone_changed)


func add(amount: int) -> void:
	gold_shells += amount
	SignalBus.gold_shells_changed.emit(gold_shells)


func remove(amount: int) -> void:
	gold_shells = max(0, gold_shells - amount)
	SignalBus.gold_shells_changed.emit(gold_shells)


func can_afford(amount: int) -> bool:
	return gold_shells >= amount


func _earn_post_combat() -> void:
	var earned: int = GameRules.GOLD_SHELLS_BASE
	if _hands_this_zone < GameRules.GOLD_SHELLS_FAST_THRESHOLD:
		earned += GameRules.GOLD_SHELLS_BONUS_FAST
	elif _hands_this_zone < GameRules.GOLD_SHELLS_QUICK_THRESHOLD:
		earned += GameRules.GOLD_SHELLS_BONUS_QUICK
	add(earned)
	SignalBus.gold_shells_earned.emit(earned)


# ── Signals ────────────────────────────────────────────────────────────────────

func _on_run_started() -> void:
	gold_shells = 0
	_hands_this_zone = 0
	SignalBus.gold_shells_changed.emit(gold_shells)


func _on_hand_resolved(_result: StringName, _payout: int) -> void:
	_hands_this_zone += 1


func _on_zone_completed() -> void:
	_earn_post_combat()


func _on_zone_changed(_zone_number: int) -> void:
	_hands_this_zone = 0
