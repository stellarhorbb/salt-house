# scripts/managers/battle_manager.gd
# Autoload "BattleManager" — orchestrates the combat flow.
# Coordinates other managers via signals. Contains no calculation logic.
extends Node


var current_bet: int = 0
var player_hand: Array[CardResource] = []
var player_score: int = 0
var _is_player_turn: bool = false


func _ready() -> void:
	SignalBus.bet_placed.connect(_on_bet_placed)
	SignalBus.player_hit.connect(_on_player_hit)
	SignalBus.player_stood.connect(_on_player_stood)
	SignalBus.player_doubled.connect(_on_player_doubled)


func start_hand(bet: int) -> void:
	current_bet = bet
	player_hand.clear()
	player_score = 0
	_is_player_turn = true
	SignalBus.hand_started.emit()
	SignalBus.bet_placed.emit(bet)

	# Distribution standard BJ : joueur, dealer (visible), joueur, dealer (caché)
	_deal_to_player()
	_deal_to_dealer_visible()
	_deal_to_player()
	_deal_to_dealer_hole()

	# Blackjack naturel — révélation + résolution immédiate
	if player_score == GameRules.BUST_THRESHOLD and player_hand.size() == 2:
		_is_player_turn = false
		SignalBus.dealer_card_revealed.emit(DealerManager.hole_card)
		var payout := int(current_bet * PressureManager.pressure * GameRules.BLACKJACK_MULTIPLIER)
		SignalBus.hand_resolved.emit(&"blackjack", payout)


func _deal_to_player() -> void:
	var card: CardResource = DeckManager.draw()
	if card:
		player_hand.append(card)
		player_score = _calculate_score(player_hand)
		SignalBus.card_drawn.emit(card)


func _deal_to_dealer_visible() -> void:
	var card: CardResource = EntityDeckManager.draw()
	if card:
		DealerManager.receive_card(card)
		SignalBus.dealer_card_drawn.emit(card)


func _deal_to_dealer_hole() -> void:
	var card: CardResource = EntityDeckManager.draw()
	if card:
		DealerManager.receive_hole_card(card)
		SignalBus.dealer_hole_dealt.emit()


func _resolve_hand() -> void:
	_is_player_turn = false
	SignalBus.dealer_card_revealed.emit(DealerManager.hole_card)
	DealerManager.play_turn()

	var result: StringName
	var payout: int = 0

	if player_score > GameRules.BUST_THRESHOLD:
		result = &"bust"
	elif DealerManager.score > GameRules.BUST_THRESHOLD or player_score > DealerManager.score:
		if player_score == GameRules.BUST_THRESHOLD:
			# 21 au tirage — dégâts × 1.5
			result = &"twenty_one"
			payout = int(current_bet * PressureManager.pressure * GameRules.TWENTY_ONE_MULTIPLIER)
		else:
			result = &"win"
			payout = int(current_bet * PressureManager.pressure)
	elif player_score == DealerManager.score:
		result = &"push"
		payout = current_bet
	else:
		result = &"lose"

	SignalBus.hand_resolved.emit(result, payout)


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

func _on_bet_placed(_amount: int) -> void:
	pass  # Bet is already handled in start_hand


func _on_player_hit() -> void:
	if not _is_player_turn:
		return
	_deal_to_player()
	if player_score > GameRules.BUST_THRESHOLD:
		_resolve_hand()


func _on_player_stood() -> void:
	if not _is_player_turn:
		return
	_resolve_hand()


func _on_player_doubled() -> void:
	if not _is_player_turn or player_hand.size() != 2:
		return
	# Extra = mise initiale, plafonné au salt restant du joueur
	var extra: int = mini(current_bet, BankrollManager.salt)
	current_bet += extra
	SignalBus.bet_increased.emit(extra)
	# Une seule carte, puis résolution directe
	_deal_to_player()
	_resolve_hand()
