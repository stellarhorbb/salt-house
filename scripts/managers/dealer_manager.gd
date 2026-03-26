# scripts/managers/dealer_manager.gd
# Autoload "DealerManager" — sole owner of the dealer's hand.
# Handles automatic drawing up to the stand threshold and score calculation.
extends Node


var hand: Array[CardResource] = []
var score: int = 0
var hole_card: CardResource = null


func _ready() -> void:
	SignalBus.hand_started.connect(_on_hand_started)


func reset_hand() -> void:
	hand.clear()
	score = 0
	hole_card = null


func receive_card(card: CardResource) -> void:
	hand.append(card)
	score = _calculate_score(hand)


# Carte cachée — ajoutée à la main (score réel calculé) mais non révélée visuellement
func receive_hole_card(card: CardResource) -> void:
	hole_card = card
	hand.append(card)
	score = _calculate_score(hand)


func play_turn() -> void:
	# Dealer draws until reaching the stand threshold
	while score < GameRules.DEALER_STAND_THRESHOLD:
		var card: CardResource = EntityDeckManager.draw()
		if card == null:
			break
		receive_card(card)
		SignalBus.dealer_card_drawn.emit(card)


func _calculate_score(cards: Array) -> int:
	var total := 0
	var aces := 0

	for card in cards:
		if card.is_ace:
			aces += 1
			total += GameRules.ACE_HIGH_VALUE
		else:
			total += card.value

	while total > GameRules.BUST_THRESHOLD and aces > 0:
		total -= GameRules.ACE_HIGH_VALUE - GameRules.ACE_LOW_VALUE
		aces -= 1

	return total


# ── Signals ────────────────────────────────────────────────────────────────────

func _on_hand_started() -> void:
	reset_hand()
