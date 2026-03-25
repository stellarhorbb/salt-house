# scripts/managers/deck_manager.gd
# Autoload "DeckManager" — sole owner of the player's deck.
# Handles generation, shuffling, drawing, and discarding.
extends Node


var _deck: Array[CardResource] = []
var _discard: Array[CardResource] = []


func _ready() -> void:
	SignalBus.run_started.connect(_on_run_started)
	SignalBus.zone_changed.connect(_on_zone_changed)


# ── Build ──────────────────────────────────────────────────────────────────────

func build_standard_deck() -> void:
	_deck.clear()
	_discard.clear()

	var families := [
		CardResource.FAMILY_DIAMONDS,
		CardResource.FAMILY_HEARTS,
		CardResource.FAMILY_SPADES,
		CardResource.FAMILY_CLUBS,
	]

	for family in families:
		# Ace
		var ace := CardResource.new()
		ace.family = family
		ace.value = 1
		ace.is_ace = true
		ace.display_name = "A"
		_deck.append(ace)

		# 2 → 10
		for n in range(2, 11):
			var card := CardResource.new()
			card.family = family
			card.value = n
			card.is_ace = false
			card.display_name = str(n)
			_deck.append(card)

		# Face cards (value 10)
		for face in ["J", "Q", "K"]:
			var card := CardResource.new()
			card.family = family
			card.value = 10
			card.is_ace = false
			card.display_name = face
			_deck.append(card)

	shuffle()


func shuffle() -> void:
	_deck.shuffle()


# ── Draw ───────────────────────────────────────────────────────────────────────

func draw() -> CardResource:
	if _deck.is_empty():
		# ⚠️ DECISION — auto-reshuffle discard or block?
		_reshuffle_discard()

	if _deck.is_empty():
		return null

	var card: CardResource = _deck.pop_back()
	return card


func discard(card: CardResource) -> void:
	_discard.append(card)


func _reshuffle_discard() -> void:
	_deck = _discard.duplicate() as Array[CardResource]
	_discard.clear()
	shuffle()


func remaining() -> int:
	return _deck.size()


# ── Signals ────────────────────────────────────────────────────────────────────

func _on_run_started() -> void:
	build_standard_deck()


func _on_zone_changed(_zone_number: int) -> void:
	build_standard_deck()
