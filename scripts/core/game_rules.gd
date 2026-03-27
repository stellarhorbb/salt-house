# scripts/core/game_rules.gd
# Autoload "GameRules" — all game rule constants.
# No magic numbers in code: any value that could change lives here.
# Values marked "⚠️ BALANCING" are placeholders to be tuned later.
extends Node


# ── Blackjack ──────────────────────────────────────────────────────────────────
const BUST_THRESHOLD         := 21
const ACE_HIGH_VALUE         := 11
const ACE_LOW_VALUE          := 1
const DEALER_STAND_THRESHOLD := 17  # ⚠️ BALANCING — classic 17, to be validated

# ── Pressure ───────────────────────────────────────────────────────────────────
const PRESSURE_BASE            := 1.0
const PRESSURE_PER_HIT         := 0.1  # ⚠️ BALANCING — pressure bonus per card drawn beyond the 2 initial cards
const PRESSURE_FAMILY_BONUS    := 0.3   # ⚠️ BALANCING — 3 cards same family → +pressure
const PRESSURE_BLACKJACK_SPIKE := 1.0   # ⚠️ BALANCING — pressure bonus on exact 21

# ── Combat ─────────────────────────────────────────────────────────────────────
const TWENTY_ONE_MULTIPLIER          := 1.5   # ⚠️ BALANCING — 21 au tirage → payout × 1.5
const BLACKJACK_MULTIPLIER           := 2.0   # ⚠️ BALANCING — blackjack naturel (2 cartes) → payout × 2
const HAND_RESULT_DISPLAY_DURATION   := 2.0   # durée d'affichage du résultat avant transition

# ── Economy ────────────────────────────────────────────────────────────────────
const STARTING_SALT              := 100  # ⚠️ BALANCING — player starting Salt
const SHOP_REROLL_COSTS: Array[int] = [2, 3, 5, 8]  # Fibonacci — 4ème reroll hors de portée sans bonus

# ── Deck ───────────────────────────────────────────────────────────────────────
const DECK_SIZE        := 52
const CARDS_PER_FAMILY := 13    # Ace + 2-10 + Jack/Queen/King

# ── Echoes ─────────────────────────────────────────────────────────────────────
const MAX_ECHO_SLOTS := 5     # ⚠️ BALANCING — maximum equipped echoes

# ── Gold Shells ─────────────────────────────────────────────────────────────────
const GOLD_SHELLS_BASE          := 8    # ⚠️ BALANCING — base per combat win
const GOLD_SHELLS_BONUS_FAST    := 4    # ⚠️ BALANCING — bonus if win in < 3 hands
const GOLD_SHELLS_BONUS_QUICK   := 2    # ⚠️ BALANCING — bonus if win in < 5 hands
const GOLD_SHELLS_FAST_THRESHOLD  := 3  # win in strictly fewer than 3 hands
const GOLD_SHELLS_QUICK_THRESHOLD := 5  # win in strictly fewer than 5 hands
const SHOP_MOON_PACK_PRICE        := 10  # ⚠️ BALANCING — cost of one Moon Pack in Gold Shells
