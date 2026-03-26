## Contexte
Suite de la session du 26 mars (après-midi). Boucle de jeu complète implémentée.

---

## Ce qu'on a fait

### 1. Carte cachée du dealer
- Distribution standard BJ : joueur / dealer face-up / joueur / dealer face-down
- Hole card stockée dans `DealerManager` — score vrai calculé dès le deal mais masqué visuellement
- Score affiché = carte visible uniquement tant que le joueur joue
- Au Stand (et Blackjack naturel) : signal `dealer_card_revealed(card)` → flip animation

### 2. Animations de cartes
- Deal-in : scale 0.75→1 + fade-in, staggeré de 0.12s par carte (4 cartes initiales = 0.36s au total)
- Révélation hole card : flip horizontal (scale.x → 0, change style, scale.x → 1)
- `CardVisual` refactoré : `setup()`, `setup_hidden()`, `reveal()`, `_apply_card_style()`, `_apply_hidden_style()`
- Classe `CardVisual` nommée (`class_name CardVisual`) pour typage fort

### 3. Entity progress bar animée
- `_on_entity_salt_changed` tweene la progress bar (CUBIC OUT, 0.4s) au lieu de sauter
- `_refresh_top_bar()` allégé — ne touche plus à l'entity bar
- Reset net à 100% au changement de zone

### 4. Chips de mise en %
- 6 boutons : 10% / 25% / 50% / 75% / ALL IN / X (clear)
- Chaque clic **fixe** la mise directement (non additif)
- Scaling automatique — zéro maintenance par zone
- Dopamine préservée via le StakeDisplay qui affiche le gros chiffre

### 5. Boucle complète zone → reward → shop → zone suivante
- `EntityManager._advance_zone()` splitté : émet `zone_completed`, stocke `_pending_zone`, navigue vers reward
- `EntityManager.proceed_to_next_zone()` : `load_zone()` + `SceneManager.go_to("battle")` + `zone_changed`
- `SceneManager.init()` accepte un `current_scene` optionnel — fallback pour lancer battle_scene directement depuis l'éditeur

### 6. Reward Screen
- 2 cartes générées aléatoirement : toujours 1 PRSR + 1 Salt, rareté tirée (50/30/15/5%)
- Couleurs par rareté : Common #343536 / Uncommon #707caa / Rare #204ef4 / Legendary #f1a21a
- Design Figma implémenté : zone name + "ZONE CLEARED" + 2 cartes cliquables
- Hover : modulate ×1.15
- `RewardResource` : classe générative (pas de .tres), `generate()`, `get_display_value()`, `get_type_label()`

### 7. Shop stub
- Écran minimal : titre SHOP + salt affiché + bouton LEAVE
- Contenu (Echoes, Shells) à implémenter dans une session dédiée

### 8. Bugs corrigés
- **Score dealer après draws supplémentaires** : flag `_hole_revealed` — après révélation, affiche `DealerManager.score` complet
- **Deck vide en zone 3** : `DeckManager` suit les cartes `_in_play`, les défausse à `hand_resolved`, reshuffle automatique
- **Salt affiché à 500 au démarrage** : signal `entity_salt_changed` arrivait avant que battle_scene soit dans le tree — init explicite dans `_ready()`
- **Salt reset à 100 entre zones** : même problème sur `salt_amount_label` — init dans `_on_zone_changed()`
- **SceneManager container null** : fallback `SceneManager.init(get_parent(), self)` dans battle_scene._ready()

---

## Décisions de design prises

- **Mise en %** (10/25/50/75/ALL IN/X) — non additif, fixe directement. Scaling auto, dopamine via StakeDisplay
- **Reward : toujours 1 PRSR + 1 Salt** — garantit un choix meaningful à chaque zone
- **Rareté indépendante pour chaque carte** — les deux peuvent être legendary ou common

---

## Questions ouvertes restantes
- Shop : contenu réel (Echoes via Shells, catalogue)
- Moon Cards : implémentation des 4 cartes
- Chips de mise par zone (maintenant inutile grâce aux %)
- Valeurs de balancing PRSR (actuellement +0.1/hit)
- Remélange du deck entre les mains (actuellement reshuffle uniquement quand vide)
- Salt de départ du joueur

---

## Prochaines étapes suggérées
1. Moon Cards niveau 1 (4 cartes, effets passifs)
2. Shop réel — EchoResource + ShellResource + catalogue
3. Balancing global (PRSR, salt pools par zone, salt de départ)
