# 09 — Spécifications Techniques

## 9.1 Architecture Godot 4.6

```
Resources :
  CardResource.gd         — Famille, Valeur, Sprite, effets spéciaux éventuels
  EchoResource.gd         — Nom, Description, Trigger, Effet
  MoonCardResource.gd     — Nom, Description, Famille associée, Modificateur de règle
  ShellResource.gd        — Type, Effet, Sprite
  EntityResource.gd       — Salt pool, Seuil dealer, Deck composition, Mutations actives

Managers (Autoloads) :
  SignalBus.gd            — Bus de signaux global, communication entre systèmes
  GameManager.gd          — Run state, Depth courant, progression globale
  SceneManager.gd         — Navigation entre scènes
  BankrollManager.gd      — Salt courant, mises, gains/pertes
  DeckManager.gd          — Composition du deck joueur, draw, shuffle, retrait
  EntityDeckManager.gd    — Deck indépendant du dealer
  PressureManager.gd      — Calcul et accumulation du PRSR
  BattleManager.gd        — Orchestration du combat, coordination des managers
  DealerManager.gd        — Main et logique du dealer
  EntityManager.gd        — Salt pool entité, progression de zones
  ShopManager.gd          — Génération et gestion de l'inventaire Shop
```

**Principes d'architecture :**
- Communication entre systèmes → **Signals uniquement** via SignalBus. Jamais d'appel direct entre Managers.
- Un Manager = une responsabilité
- Toute valeur de balancing → `game_rules.gd` ou `.tres`. Zéro magic number dans le code.
- Tous les identifiants en anglais (variables, fonctions, classes, signaux, fichiers).

---

## 9.2 Machine à États (BattleManager)

```
IDLE
  → BETTING        : Le joueur choisit sa mise
  → PLAYER_DRAW    : Phase de tirage (Hit / Stand / Double)
  → BUST_CHECK     : Vérifie si > 21
  → DEALER_REVEAL  : Le dealer tire ses cartes
  → RESOLUTION     : Calcul Mise × PRSR, transfer Salt joueur ↔ pool Entité
  → COMBAT_END     : Entité morte ou Salt = 0
  → REWARD         : Écran de récompense
  → SHOP           : Boutique
```

---

## 9.3 Valeurs de Balancing (game_rules.gd)

| Constante | Valeur actuelle | Note |
|---|---|---|
| BUST_THRESHOLD | 21 | Fixe |
| ACE_HIGH_VALUE | 11 | Fixe |
| ACE_LOW_VALUE | 1 | Fixe |
| DEALER_STAND_THRESHOLD | 17 | ⚠️ BALANCING |
| PRESSURE_BASE | 1.0 | ⚠️ BALANCING |
| PRESSURE_PER_HIT | 0.1 | ⚠️ BALANCING |
| BLACKJACK_MULTIPLIER | 2.0 | ⚠️ BALANCING |
| STARTING_SALT | 100 | ⚠️ BALANCING |
| HAND_RESULT_DISPLAY_DURATION | 2.0s | UX |
