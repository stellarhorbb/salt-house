## Contexte
Session du 27 mars. Focus sur le gameplay BJ, le balancing PRSR/Salt, et la documentation GDD.

---

## Ce qu'on a fait

### 1. Double Down
- Disponible uniquement sur la main initiale (2 cartes)
- Salt suffisant → stake × 2 / Salt insuffisant → stake + tout le Salt restant
- Bouton "DOUBLE" ou "ALL IN DOUBLE" selon le Salt disponible
- Une carte tirée → résolution directe, pas de Hit/Stand après
- Signaux ajoutés : `player_doubled`, `bet_increased(extra)`
- `BattleManager._on_player_doubled()` : calcule l'extra, émet `bet_increased`, tire 1 carte, résout
- `BankrollManager._on_bet_increased()` : ajoute l'extra à `_current_bet`, retire du salt
- `DoubleButton` ajouté dans la scène, caché par défaut, affiché après les 2 cartes initiales

### 2. Fix transition Reward Screen
- Bug : la dernière main disparaissait instantanément au profit du Reward Screen
- Cause : `EntityManager.steal()` → `_advance_zone()` → `SceneManager.go_to("reward")` de façon synchrone, avant le timer 2s de la battle_scene
- Fix : `await get_tree().create_timer(GameRules.HAND_RESULT_DISPLAY_DURATION).timeout` dans `_advance_zone()` (et sur `run_ended`)
- `HAND_RESULT_DISPLAY_DURATION = 2.0` centralisé dans `game_rules.gd`

### 3. Séparateur de milliers
- Helper `_fmt(n: int) -> String` ajouté dans `battle_scene.gd`
- Appliqué sur tous les affichages Salt (joueur, entité, mise, payout)
- PRSR affiché en `"%.1f"` (1 décimale) — ex : 1.0, 1.1, 1.2

### 4. Balancing PRSR / Salt — explorations
- Plusieurs tentatives de rescaling pour avoir des entiers propres
- Conclusion : on revient aux valeurs d'origine
  - `STARTING_SALT = 100`
  - `PRESSURE_BASE = 1.0`, `PRESSURE_PER_HIT = 0.1`
  - Entity salt pools : 100 / 250 / 500 / 1 000 / 2 000 / 4 000 / 8 000 / 16 000
  - Payout : `stake × pressure` (pas de division)

### 5. EntityDeckManager committé
- Oublié lors des sessions précédentes — deck indépendant pour le dealer
- Autoload enregistré dans `project.godot`

### 6. GDD restructuré
- Ancien fichier monolithique `salt-house-gdd-full.md` découpé en 11 fichiers
- Archivé dans `docs/gdd/11 - Archives/`
- Structure finale :
  - `00 - INDEX.md`
  - `00 - Univers.md`
  - `01` à `10` — une section par fichier

---

## Décisions de design prises

- **Double Down** : main initiale uniquement, all-in partiel autorisé si salt insuffisant
- **Push, 21 tiré, all-in** : pas de récompense dans les règles de base — réservé aux Echoes
- **Tempo de zone** : pas de bonus/malus sur nombre de turns — réservé aux Echoes (famille "Tempo")
- **DEALER_STAND_THRESHOLD = 17** : valeur classique, levier de difficulté futur via Mutations/zones
- **PRSR** : valeurs d'origine conservées (1.0 base, +0.1/hit) — lisibilité via `%.1f`
- **Bet Buttons** : système roguelite documenté dans le GDD (section 04)
  - 4 slots perso + ALL-IN épinglé permanent
  - Buttons à valeur spéciale et à effet spécial
  - Acquisition via Button Packs au Shop

---

## Familles d'Echoes identifiées cette session

- **Cas limites** — push, 21 tiré, all-in
- **Tempo** — vitesse de zone, nombre de turns
- **PRSR / risque** — hits, mains longues

---

## Questions ouvertes restantes (section 10)
- Noms des 4 familles
- Seuil dealer variable par zone ?
- Nombre de slots Echoes et Moon Cards
- Shells utilisables en combat ?
- Catalogue Bet Buttons spéciaux (session dédiée à prévoir)
- Button Packs : remplacent ou s'ajoutent ?

---

## Prochaines étapes suggérées
1. Moon Cards niveau 1 — implémentation (4 cartes, effets passifs)
2. Shop réel — EchoResource + ShellResource + catalogue
3. Bet Buttons spéciaux — session de brainstorm effets
4. Balancing global au playtest
