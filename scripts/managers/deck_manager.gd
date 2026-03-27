# scripts/managers/deck_manager.gd
# Autoload "DeckManager" — sole owner of the player's deck.
# Handles generation, shuffling, drawing, and discarding.
extends Node


var _deck: Array[CardResource] = []
var _discard: Array[CardResource] = []
var _in_play: Array[CardResource] = []  # cartes actuellement sur la table
var _removed_keys: Array[String] = []   # cartes supprimées définitivement du run


func _ready() -> void:
	SignalBus.run_started.connect(_on_run_started)
	SignalBus.zone_changed.connect(_on_zone_changed)
	SignalBus.hand_resolved.connect(_on_hand_resolved)


# ── Build ──────────────────────────────────────────────────────────────────────

func build_standard_deck() -> void:
	_deck.clear()
	_discard.clear()
	_in_play.clear()

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

	# Filtrage des cartes supprimées définitivement
	_deck = _deck.filter(func(c: CardResource) -> bool:
		return not _removed_keys.has(_card_key(c))
	)

	shuffle()


func shuffle() -> void:
	_deck.shuffle()


# ── Draw ───────────────────────────────────────────────────────────────────────

func draw() -> CardResource:
	if _deck.is_empty():
		_reshuffle_discard()
	if _deck.is_empty():
		return null
	var card: CardResource = _deck.pop_back()
	_in_play.append(card)
	return card


func _reshuffle_discard() -> void:
	_deck = _discard.duplicate() as Array[CardResource]
	_discard.clear()
	shuffle()


func remaining() -> int:
	return _deck.size()


# Cartes encore dans la pioche (pas encore tirées cette zone)
func get_draw_pile() -> Array[CardResource]:
	return _deck.duplicate() as Array[CardResource]


# Toutes les cartes du run (deck + défausse + en jeu), exclut les supprimées
func get_all_cards() -> Array[CardResource]:
	var all: Array[CardResource] = []
	all.append_array(_deck)
	all.append_array(_discard)
	all.append_array(_in_play)
	return all


# Retourne count cartes aléatoires du deck sans les retirer (pour le choix Blood Moon)
func get_sample(count: int) -> Array[CardResource]:
	var pool: Array[CardResource] = _deck.duplicate()
	pool.shuffle()
	var result: Array[CardResource] = []
	for i: int in mini(count, pool.size()):
		result.append(pool[i])
	return result


# Supprime définitivement une carte du run (Blood Moon)
func remove_from_pool(card: CardResource) -> void:
	var key: String = _card_key(card)
	if not _removed_keys.has(key):
		_removed_keys.append(key)
	# Suppression immédiate du deck et de la défausse si présente
	_deck = _deck.filter(func(c: CardResource) -> bool: return _card_key(c) != key)
	_discard = _discard.filter(func(c: CardResource) -> bool: return _card_key(c) != key)


func _card_key(card: CardResource) -> String:
	return "%s_%s" % [card.family, card.display_name]


# ── Signals ────────────────────────────────────────────────────────────────────

func _on_run_started() -> void:
	_removed_keys.clear()
	build_standard_deck()


func _on_zone_changed(_zone_number: int) -> void:
	build_standard_deck()


func _on_hand_resolved(_result: StringName, _payout: int) -> void:
	# Toutes les cartes jouées retournent à la défausse
	_discard.append_array(_in_play)
	_in_play.clear()
