# scripts/resources/reward_resource.gd
# Représente une récompense post-zone : PRSR boost ou Salt bonus.
# Généré dynamiquement — ne pas sauvegarder en .tres.
class_name RewardResource
extends Resource


const RARITY_COLORS := {
	&"common":    Color(0.204, 0.208, 0.212),  # #343536
	&"uncommon":  Color(0.439, 0.486, 0.667),  # #707caa
	&"rare":      Color(0.125, 0.306, 0.957),  # #204ef4
	&"legendary": Color(0.945, 0.635, 0.102),  # #f1a21a
}

const PRSR_VALUES := {
	&"common":    0.05,
	&"uncommon":  0.10,
	&"rare":      0.20,
	&"legendary": 0.50,
}

const SALT_VALUES := {
	&"common":    0.01,
	&"uncommon":  0.02,
	&"rare":      0.05,
	&"legendary": 0.20,
}

var type: StringName    # &"prsr" | &"salt"
var rarity: StringName  # &"common" | &"uncommon" | &"rare" | &"legendary"
var value: float


static func generate(reward_type: StringName, reward_rarity: StringName) -> RewardResource:
	var r := RewardResource.new()
	r.type = reward_type
	r.rarity = reward_rarity
	r.value = PRSR_VALUES[reward_rarity] if reward_type == &"prsr" else SALT_VALUES[reward_rarity]
	return r


func get_rarity_color() -> Color:
	return RARITY_COLORS.get(rarity, Color.WHITE)


func get_display_value() -> String:
	if type == &"prsr":
		return "+%.2f" % value
	return "+%d%%" % int(value * 100.0)


func get_type_label() -> String:
	return "PRSR BOOST" if type == &"prsr" else "SALT"
