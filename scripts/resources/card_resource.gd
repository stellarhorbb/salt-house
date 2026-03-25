# scripts/resources/card_resource.gd
# Defines a single card in the player's deck.
# Family names use classic suits as placeholders — rename to thematic names once decided.
class_name CardResource
extends Resource


# Familles — noms classiques en attendant les noms thématiques
const FAMILY_DIAMONDS := &"diamonds"  # Orange — ♦
const FAMILY_HEARTS   := &"hearts"    # Rouge  — ♥
const FAMILY_SPADES   := &"spades"    # Noir   — ♠
const FAMILY_CLUBS    := &"clubs"     # Bleu   — ♣

# Couleur du jeton par famille
const FAMILY_COLORS := {
	&"diamonds": Color(0.976, 0.620, 0.047),
	&"hearts":   Color(0.871, 0.106, 0.106),
	&"spades":   Color(0.08,  0.08,  0.08 ),
	&"clubs":    Color(0.247, 0.537, 0.906),
}

@export var family: StringName  # &"diamonds" | &"hearts" | &"spades" | &"clubs"
@export var value: int                   # BJ value: 1-10 (Ace = 1, face cards = 10)
@export var is_ace: bool = false
@export var display_name: String         # "A", "2"…"10", "J", "Q", "K"


func get_color() -> Color:
	return FAMILY_COLORS.get(family, Color.WHITE)
