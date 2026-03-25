## Contexte
Suite de la session du 25 mars. Architecture de base posée, on attaque l'implémentation du combat complet.

---

## Ce qu'on a fait

### 1. Combat fonctionnel de bout en bout
- Cartes dealer et joueur correctement routées via signaux séparés (`card_drawn` / `dealer_card_drawn`)
- Score joueur et dealer calculés et affichés en temps réel
- Résolution de main complète : win / lose / bust / push / blackjack
- Pause de 2 secondes sur le résultat, retour automatique à l'écran de mise

### 2. Économie Salt câblée
- **Nouveau modèle validé** : sur victoire, le joueur récupère sa mise + vole `Mise × PRSR` à l'entity
  - Exemple : mise 100, PRSR 1.2 → joueur récupère 220, entity perd 120
  - Intuitif (cohérent avec le BJ classique), dopamine sur les gros multiplieurs
- Mise déduite au DEAL, remboursée sur win/blackjack/push via `BankrollManager`
- Salt volé transité via signal `salt_stolen` → `BankrollManager.add()`
- Game over si salt joueur ≤ 0 après résolution de main (pas avant)

### 3. Entity & Progression de zones
- Architecture `EntityResource` + `EntityProgressionResource` + `ZoneStatsResource` (inspiré BagBattler)
- 4 zones définies dans `entity_progression.tres` :
  - Zone 1 — The Surface (100 salt)
  - Zone 2 — The Shallows (150 salt)
  - Zone 3 — The Deep (250 salt, 1 mutation)
  - Zone 4 — The Abyss (350 salt, 2 mutations, boss)
- Progression automatique de zone sur entity défaite, victoire finale à la zone 4
- Deck rebuild à chaque nouvelle zone (évite le deck vide en zone 3+)
- PRSR reset entre chaque zone (déjà câblé via `zone_completed`)

### 4. UI — TopBar & StakeDisplay
- TopBar : ZoneInfo (gauche), EntityBarContainer (centre, turns + salt entity + progress bar), SaltInfo (droite)
- StakeDisplay : SaltColumn (label au-dessus, panel valeur en dessous) + MultiplierLabel aligné + PressureColumn
- Progress bar entity en noir via StyleBoxFlat inline
- `ui_margin` export sur BattleScene pour padding global (via node `Content`)

### 5. Design Moon Cards tranché
Symétrie 2×2 validée :

|  | Croissance | Sécurité |
|---|---|---|
| **PRSR** | Last Quarter (+PRSR/hit) | First Quarter (plancher PRSR) |
| **Salt** | Full Moon (+% salt volé) | New Moon (récupère % sur perte) |

- Quatre playstyles distincts : snowball agressif / safe bankroll / high stakes / résilient
- Combos lisibles : Last+Full = aggro, First+New = safe, etc.

---

## Décisions de design prises

- **Pas de plafond de mise** — le joueur peut all-in, c'est sa prise de risque, crée des moments mémorables
- **Mise = avance remboursée** sur victoire (pas un coût permanent) — cohérent avec l'instinct BJ
- **Chips additifs** (cliquer plusieurs fois pour monter la mise) — plus addictif qu'un sélecteur unique
- **New Moon** = récupère X% de la mise sur perte (pas un % max bet — inutile sans plafond)

---

## Questions ouvertes restantes
- Dénominations des chips de mise par zone (actuellement +10/+20/+50/+100 hardcodés)
- Carte cachée du dealer (actuellement tout visible — à implémenter)
- Shop et rewards entre les zones
- Noms et effets précis des Moon Cards niveau 1, 2, 3
- Valeurs de balancing PRSR (actuellement +0.1/hit)

---

## Prochaines étapes suggérées
1. Chips de mise par zone dans `ZoneStatsResource`
2. Carte cachée du dealer + révélation au stand
3. Transition de zone (écran intermédiaire / shop)
4. Moon Cards niveau 1 implémentées
