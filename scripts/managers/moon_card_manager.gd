# scripts/managers/moon_card_manager.gd
# Autoload "MoonCardManager" — tracks active Moon Card bonuses for the run.
# Moon Cards are consumed on acquisition — effects accumulate, never reset mid-run.
# Resets fully on run_started.
extends Node


var pressure_base_bonus: float = 0.0
var pressure_per_hit_bonus: float = 0.0
var salt_steal_bonus_pct: float = 0.0
var salt_recovery_pct: float = 0.0

var _current_bet: int = 0


func _ready() -> void:
	SignalBus.run_started.connect(_on_run_started)
	SignalBus.bet_placed.connect(_on_bet_placed)
	SignalBus.bet_increased.connect(_on_bet_increased)
	SignalBus.salt_stolen.connect(_on_salt_stolen)
	SignalBus.hand_resolved.connect(_on_hand_resolved)


func apply(card: MoonCardResource) -> void:
	match card.effect_type:
		MoonCardResource.EffectType.PRESSURE_BASE_BONUS:
			pressure_base_bonus += card.value
		MoonCardResource.EffectType.PRESSURE_PER_HIT_BONUS:
			pressure_per_hit_bonus += card.value
		MoonCardResource.EffectType.SALT_STEAL_BONUS_PCT:
			salt_steal_bonus_pct += card.value
		MoonCardResource.EffectType.SALT_RECOVERY_PCT:
			salt_recovery_pct += card.value
	SignalBus.moon_card_applied.emit(card)


# ── Signals ────────────────────────────────────────────────────────────────────

func _on_run_started() -> void:
	pressure_base_bonus = 0.0
	pressure_per_hit_bonus = 0.0
	salt_steal_bonus_pct = 0.0
	salt_recovery_pct = 0.0
	_current_bet = 0


func _on_bet_placed(amount: int) -> void:
	_current_bet = amount


func _on_bet_increased(extra: int) -> void:
	_current_bet += extra


func _on_salt_stolen(amount: int) -> void:
	if salt_steal_bonus_pct <= 0.0:
		return
	var bonus: int = int(amount * salt_steal_bonus_pct)
	if bonus > 0:
		BankrollManager.add(bonus)


func _on_hand_resolved(result: StringName, _payout: int) -> void:
	# New Moon : récupère X% de la mise sur défaite non-bust uniquement
	if result == &"lose" and salt_recovery_pct > 0.0:
		var recovery: int = ceili(_current_bet * salt_recovery_pct)
		if recovery > 0:
			BankrollManager.add(recovery)
	_current_bet = 0
