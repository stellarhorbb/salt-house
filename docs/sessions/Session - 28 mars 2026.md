# Session — 28 mars 2026

## Objectifs accomplis

### Animation du tirage des cartes
- Nouveau système async dans `battle_manager.gd` et `dealer_manager.gd`
- Ordre de distribution revu : 2 cartes joueur → pause 0.5s → 2 cartes dealer
- `player_turn_started` signal émis après le deal initial et après chaque hit sans bust
- Boutons Hit/Stand/Double désactivés pendant le deal, réactivés via `player_turn_started`
- Double toujours visible mais disabled après le premier hit (hand.size > 2)
- Scores cachés pendant le deal, révélés au bon moment (player : `player_turn_started`, dealer : `dealer_card_revealed`)

### Constantes de timing dans `game_rules.gd`
- `CARD_DEAL_DELAY = 0.15` — délai intra-groupe
- `DEAL_GROUP_PAUSE = 0.5` — pause entre groupe joueur et groupe dealer
- `DEALER_DRAW_DELAY = 0.6` — délai entre chaque carte du dealer en résolution

### Bugs Moon Cards corrigés
- **New Moon** : `int()` remplacé par `ceili()` — les petites mises ne donnaient plus 0 salt de récupération
- **First Quarter** : `PressureManager` reset sur `zone_changed` (en plus de `zone_completed`) — le bonus s'applique dès la zone après achat
- **Fatal loss + New Moon** : `run_ended` différé via `call_deferred` — la récupération peut s'appliquer avant game over
- New Moon ne se déclenche que sur `&"lose"` (pas sur `&"bust"`) — comportement confirmé correct

### Animations de résolution
- **Entity salt** : gelé visuellement pendant la main, anime en rouge après le résultat (counting 1.2s)
- **Player salt (HUD)** : tween avec flash couleur (vert = gain, rouge = perte, 0.7s)
- **Punch animation** sur les deux labels : scale 1.0 → 1.4 → 1.0 + tilt ±7° (TRANS_SPRING)
- **Result label** : fondu à l'apparition
- **Flying salt icons** : 20 icônes Sprite2D (taille = salt icon HUD) en arc de Bézier cubique erratique depuis entity vers player salt, stagger 60ms, durée ~1.1s

### Signal ajouté
- `SignalBus.salt_loot_fly(from_screen: Vector2, amount: int)` — déclenche les icônes volantes

### Séquence de résolution complète
1. Dealer joue (cartes avec `DEALER_DRAW_DELAY`)
2. `hand_resolved` → result label fondu
3. **0.6s** → entity salt anime + flying icons partent
4. **1.8s** → retour préparation

## Fichiers modifiés
- `scripts/core/signal_bus.gd`
- `scripts/core/game_rules.gd`
- `scripts/managers/battle_manager.gd`
- `scripts/managers/dealer_manager.gd`
- `scripts/managers/bankroll_manager.gd`
- `scripts/managers/moon_card_manager.gd`
- `scripts/managers/pressure_manager.gd`
- `scripts/ui/battle_scene.gd`
- `scripts/ui/hud.gd`

## État du projet
Le combat est jouable et lisible. Les animations donnent du feedback clair sur les gains/pertes.

## Prochaines étapes possibles
- Polish UI global (fonts, couleurs, layout)
- Reward screen (choix d'Echoes ou Mutations)
- Contenu : nouvelles Echoes, nouvelles Mutations
- Game loop complète (plusieurs zones, boss final)
