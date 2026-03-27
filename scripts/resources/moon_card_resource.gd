# scripts/resources/moon_card_resource.gd
# Data definition for a Moon Card — consumed on acquisition, permanent run effect.
class_name MoonCardResource
extends Resource


enum EffectType {
	PRESSURE_BASE_BONUS,    # adds to PRSR base (First Quarter)
	PRESSURE_PER_HIT_BONUS, # adds to PRSR per hit (Last Quarter)
	SALT_STEAL_BONUS_PCT,   # % bonus to salt stolen on win (Full Moon)
	SALT_RECOVERY_PCT,      # % of stake recovered on non-bust loss (New Moon)
}

@export var card_name: String = ""
@export var phase: StringName = &""
@export var effect_type: EffectType = EffectType.PRESSURE_BASE_BONUS
@export var value: float = 0.0         # raw value: 0.25 for +25%, 0.15 for +15%
@export var icon: Texture2D
