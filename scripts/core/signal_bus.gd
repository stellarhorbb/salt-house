# scripts/core/signal_bus.gd
# Autoload "SignalBus" — global signal bus.
# All systems communicate exclusively through these signals. Never call managers directly.
extends Node


# ── Run ────────────────────────────────────────────────────────────────────────
signal run_started()
signal run_ended(victory: bool)

# ── Navigation / Scenes ────────────────────────────────────────────────────────
signal scene_change_requested(scene_path: String)
signal hud_visibility_changed(visible: bool)

# ── Progression ────────────────────────────────────────────────────────────────
signal depth_completed()
signal zone_completed()
signal zone_changed(zone_number: int)

# ── Combat — flow ──────────────────────────────────────────────────────────────
signal hand_started()
signal bet_placed(amount: int)
signal player_hit()
signal player_stood()
signal hand_resolved(result: StringName, payout: int)  # result: &"win" | &"lose" | &"push" | &"bust"

# ── Combat — cards ─────────────────────────────────────────────────────────────
signal card_drawn(card)           # CardResource — player card
signal dealer_card_drawn(card)    # CardResource — dealer card (visible)
signal dealer_card_revealed()     # dealer's hidden card flipped at resolution

# ── Salt ───────────────────────────────────────────────────────────────────────
signal salt_changed(new_amount: int)
signal entity_salt_changed(new_amount: int)
signal salt_stolen(amount: int)  # player steals Salt from the Entity

# ── Pressure ───────────────────────────────────────────────────────────────────
signal pressure_changed(new_pressure: float)
signal pressure_reset()

# ── Shop / Rewards ─────────────────────────────────────────────────────────────
signal reward_selected(reward)   # EchoResource | MutationResource
signal echo_acquired(echo)       # EchoResource
signal shop_rerolled()
signal item_purchased(item)
