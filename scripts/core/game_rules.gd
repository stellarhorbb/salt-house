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
const PRESSURE_PER_HIT         := 0.1   # ⚠️ BALANCING — pressure bonus per card drawn beyond the 2 initial cards
const PRESSURE_FAMILY_BONUS    := 0.3   # ⚠️ BALANCING — 3 cards same family → +pressure
const PRESSURE_BLACKJACK_SPIKE := 1.0   # ⚠️ BALANCING — pressure bonus on exact 21

# ── Combat ─────────────────────────────────────────────────────────────────────
const BLACKJACK_MULTIPLIER := 2.0   # ⚠️ BALANCING — exact 21 → payout × 2

# ── Economy ────────────────────────────────────────────────────────────────────
const STARTING_SALT         := 100   # ⚠️ BALANCING — player starting Salt
const SHOP_REROLL_BASE_COST := 5     # ⚠️ BALANCING
const SHOP_REROLL_INCREMENT := 5     # ⚠️ BALANCING — cumulative cost per reroll

# ── Deck ───────────────────────────────────────────────────────────────────────
const DECK_SIZE        := 52
const CARDS_PER_FAMILY := 13    # Ace + 2-10 + Jack/Queen/King

# ── Echoes ─────────────────────────────────────────────────────────────────────
const MAX_ECHO_SLOTS := 5     # ⚠️ BALANCING — maximum equipped echoes

# ── Shells ─────────────────────────────────────────────────────────────────────
const MAX_SHELL_STOCK := 3    # ⚠️ BALANCING — maximum stored shells
