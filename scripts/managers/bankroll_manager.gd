# scripts/managers/bankroll_manager.gd
# Autoload "BankrollManager" — sole owner of the player's Salt.
# No other system modifies this value directly.
extends Node


var salt: int = 0
var _current_bet: int = 0


func _ready() -> void:
	SignalBus.run_started.connect(_on_run_started)
	SignalBus.salt_stolen.connect(_on_salt_stolen)
	SignalBus.bet_placed.connect(_on_bet_placed)
	SignalBus.bet_increased.connect(_on_bet_increased)
	SignalBus.hand_resolved.connect(_on_hand_resolved)


func init_salt(amount: int) -> void:
	salt = amount
	SignalBus.salt_changed.emit(salt)


func add(amount: int) -> void:
	salt += amount
	SignalBus.salt_changed.emit(salt)


func remove(amount: int) -> void:
	salt = max(0, salt - amount)
	SignalBus.salt_changed.emit(salt)


func can_afford(amount: int) -> bool:
	return salt >= amount


# ── Signals ────────────────────────────────────────────────────────────────────

func _on_run_started() -> void:
	init_salt(GameRules.STARTING_SALT)


func _on_bet_placed(amount: int) -> void:
	_current_bet = amount
	remove(amount)


func _on_bet_increased(extra: int) -> void:
	_current_bet += extra
	remove(extra)


func _on_hand_resolved(result: StringName, _payout: int) -> void:
	match result:
		&"win", &"twenty_one", &"blackjack", &"push":
			add(_current_bet)
	_current_bet = 0
	if salt <= 0:
		# Différé pour laisser tous les handlers de hand_resolved s'exécuter
		# (ex: MoonCardManager peut ajouter du Salt avant qu'on vérifie)
		SignalBus.run_ended.emit.call_deferred(false)


func _on_salt_stolen(amount: int) -> void:
	add(amount)
