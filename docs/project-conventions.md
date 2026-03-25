# Salt House — Conventions & Architecture

*Référence permanente pour le développement Godot. À consulter avant toute implémentation.*

---

## 1. Principes Fondamentaux

### 1.1 Resource-driven design
Toute valeur susceptible d'être modifiée (balancing, contenu, comportement) **vit dans un `.tres`**, jamais dans le code.

- Une carte, un Echo, une Mutation, une Entité = un fichier `.tres`
- Le code ne connaît que des types (`CardResource`, `EchoResource`...), jamais des valeurs en dur
- Ajouter une nouvelle carte ou un nouvel Echo = créer un `.tres`, zéro modification de code

### 1.2 Pas de magic numbers
```gdscript
# ❌ Interdit
if prsr > 3.0:
    damage *= 2

# ✅ Correct
if prsr > GameRules.PRSR_CRITICAL_THRESHOLD:
    damage *= GameRules.CRITICAL_MULTIPLIER
```

Toutes les constantes globales de règles vivent dans `res://scripts/core/game_rules.gd`.

### 1.3 Communication par Signals
Les systèmes ne se parlent pas directement — ils émettent et écoutent des signaux.

```gdscript
# ❌ Interdit — couplage fort
BankrollManager.remove_salt(amount)

# ✅ Correct — découplage
hand_resolved.emit(result, amount)
# BankrollManager écoute ce signal
```

Chaque Manager déclare ses propres signaux en haut de fichier.

### 1.4 Un seul responsable par donnée
- Le Salt du joueur → `BankrollManager` uniquement
- Le Salt pool de l'Entité → `EntityManager` uniquement
- Le PRSR courant → `PRSRManager` uniquement

Aucun autre nœud ne modifie ces valeurs directement — il émet un signal, le Manager décide.

---

## 2. Structure des Dossiers

```
res://
├── scenes/
│   ├── battle/
│   │   ├── battle_scene.tscn
│   │   ├── hand/
│   │   │   ├── card_visual.tscn
│   │   │   └── hand_display.tscn
│   │   ├── dealer/
│   │   │   └── dealer_display.tscn
│   │   └── ui/
│   │       ├── bet_ui.tscn
│   │       ├── prsr_display.tscn
│   │       └── result_popup.tscn
│   ├── shop/
│   │   ├── shop_scene.tscn
│   │   └── shop_item.tscn
│   ├── reward/
│   │   └── reward_scene.tscn
│   └── menus/
│       ├── main_menu.tscn
│       └── game_over.tscn
│
├── resources/
│   ├── cards/
│   │   ├── _template_card.tres       ← template à dupliquer
│   │   ├── abyssal/
│   │   ├── corail/
│   │   ├── maree/
│   │   └── tempete/
│   ├── echoes/
│   │   ├── _template_echo.tres
│   │   └── [echo_name].tres
│   ├── moon_cards/
│   │   ├── _template_moon_card.tres
│   │   └── [moon_card_name].tres
│   ├── shells/
│   │   └── [shell_name].tres
│   ├── entities/
│   │   └── [depth_name].tres
│   ├── mutations/
│   │   └── [mutation_name].tres
│   └── runs/
│       └── run_state.tres            ← état sauvegardé du run en cours
│
├── scripts/
│   ├── core/
│   │   ├── game_rules.gd             ← toutes les constantes de règles
│   │   └── game_manager.gd           ← autoload, état global du run
│   ├── managers/
│   │   ├── battle_manager.gd
│   │   ├── bankroll_manager.gd
│   │   ├── deck_manager.gd
│   │   ├── dealer_manager.gd
│   │   ├── prsr_manager.gd
│   │   ├── entity_manager.gd
│   │   └── shop_manager.gd
│   ├── resources/                    ← définitions des Resource classes
│   │   ├── card_resource.gd
│   │   ├── echo_resource.gd
│   │   ├── moon_card_resource.gd
│   │   ├── shell_resource.gd
│   │   ├── entity_resource.gd
│   │   └── mutation_resource.gd
│   └── ui/
│       ├── card_visual.gd
│       ├── bet_ui.gd
│       └── prsr_display.gd
│
├── assets/
│   ├── cards/
│   │   ├── backs/                    ← 4 dos (un par famille)
│   │   └── faces/
│   │       ├── abyssal/
│   │       ├── corail/
│   │       ├── maree/
│   │       └── tempete/
│   ├── echoes/
│   ├── moon_cards/
│   ├── shells/
│   ├── entities/
│   ├── ui/
│   │   ├── frames/
│   │   ├── buttons/
│   │   └── backgrounds/
│   └── zones/                        ← backgrounds par zone
│
├── sfx/
│   ├── cards/                        ← draw, flip, bust
│   ├── combat/                       ← win, lose, critical
│   └── ui/                           ← hover, click, transition
│
└── vfx/
    ├── particles/
    └── shaders/
```

---

## 3. Définition des Resources

### CardResource
```gdscript
# scripts/resources/card_resource.gd
class_name CardResource
extends Resource

@export var family: StringName          # &"abyssal" | &"corail" | &"maree" | &"tempete"
@export var value: int                   # 1-10 (As = 1, Figures = 10)
@export var is_ace: bool = false         # As : peut valoir 1 ou 11
@export var display_name: String         # Nom affiché
@export var sprite: Texture2D
@export var special_effect: EchoResource # null si carte normale
```

### EchoResource
```gdscript
# scripts/resources/echo_resource.gd
class_name EchoResource
extends Resource

@export var echo_name: String
@export var description: String          # Texte affiché au joueur
@export var trigger: StringName          # &"on_hit" | &"on_win" | &"on_bust" | ...
@export var family_filter: StringName    # &"" = toutes familles
@export var prsr_bonus: float = 0.0
@export var salt_bonus_percent: float = 0.0
@export var bust_protection: bool = false
@export var min_bet_threshold: int = 0   # 0 = pas de condition de mise
@export var icon: Texture2D
@export var rarity: StringName           # &"common" | &"uncommon" | &"rare" | &"epic"
```

### EntityResource
```gdscript
# scripts/resources/entity_resource.gd
class_name EntityResource
extends Resource

@export var entity_name: String
@export var salt_pool: int               # "HP" de l'entité
@export var dealer_threshold: int        # Seuil auquel le dealer s'arrête de tirer
@export var deck_composition: Dictionary # { "high_cards_weight": 1.0, ... }
@export var mutations: Array[MutationResource]
@export var sprite_idle: Texture2D
@export var sprite_reveal: Texture2D
@export var depth: int                   # Depth auquel cette entité apparaît
```

### MutationResource
```gdscript
# scripts/resources/mutation_resource.gd
class_name MutationResource
extends Resource

@export var mutation_name: String
@export var description: String
@export var trigger: StringName
@export var rarity: StringName
@export var effect_value: float = 0.0    # Valeur générique (%, montant fixe...)
@export var icon: Texture2D
```

---

## 4. game_rules.gd — Constantes Globales

```gdscript
# scripts/core/game_rules.gd
class_name GameRules

# Blackjack
const BUST_THRESHOLD := 21
const ACE_HIGH_VALUE := 11
const ACE_LOW_VALUE := 1

# PRSR
const PRSR_BASE := 1.0
const PRSR_PER_HIT := 0.1             # À ajuster en balancing
const PRSR_FAMILY_BONUS := 0.3        # 3 cartes même famille → +0.3
const PRSR_BLACKJACK_SPIKE := 1.0     # Bonus PRSR sur 21 exact

# Combat
const BLACKJACK_DAMAGE_MULTIPLIER := 2.0   # 21 exact → dégâts × 2

# Économie
const STARTING_SALT := 100            # À ajuster en balancing
const SHOP_REROLL_BASE_COST := 5
const SHOP_REROLL_INCREMENT := 5
```

---

## 5. Conventions de Nommage

### Fichiers
| Type | Convention | Exemple |
|---|---|---|
| Scènes | `snake_case.tscn` | `battle_scene.tscn` |
| Scripts | `snake_case.gd` | `battle_manager.gd` |
| Resources `.tres` | `snake_case.tres` | `echo_deep_pull.tres` |
| Assets | `snake_case.png` | `card_back_abyssal.png` |

### Code GDScript
| Élément | Convention | Exemple |
|---|---|---|
| Classes | `PascalCase` | `CardResource` |
| Variables | `snake_case` | `current_prsr` |
| Constantes | `UPPER_SNAKE_CASE` | `BUST_THRESHOLD` |
| Signaux | `snake_case` (passé) | `hand_resolved`, `salt_stolen` |
| Fonctions privées | `_snake_case` | `_calculate_damage()` |

### Resources `.tres`
Nommées par contenu, préfixées par type si ambiguïté :
- `echo_blood_tide.tres`
- `mutation_black_veil.tres`
- `entity_depth_01_surface.tres`

---

## 6. Conventions UI — Éditabilité dans l'éditeur Godot

L'UI doit être **lisible et modifiable directement dans l'éditeur Godot**, sans avoir à ouvrir un script pour comprendre ce qui s'affiche.

### 6.1 Principes

**Tout nœud visible dans la scène, pas de génération cachée.**
Les éléments UI sont placés dans le scene tree — pas créés dynamiquement par un script sauf si absolument nécessaire (listes de longueur variable comme les items de shop).

```gdscript
# ❌ Interdit — UI invisible dans l'éditeur
func _ready():
    var label = Label.new()
    label.text = "PRSR"
    add_child(label)

# ✅ Correct — Label placé dans la scène, le script le trouve par @onready
@onready var prsr_label: Label = $PRSRDisplay/Label
```

**Toutes les valeurs visuelles configurables via `@export`.**
Couleurs, tailles, durées d'animation, espacements — tout ce qui peut varier est `@export` et visible dans l'Inspector, jamais dans le code.

```gdscript
# ✅ Configurable dans l'Inspector sans toucher au code
@export var win_color: Color = Color.GREEN
@export var lose_color: Color = Color.RED
@export var animation_duration: float = 0.3
```

**Un Theme Godot par type d'élément, pas de styles inline.**
Les couleurs, fonts et styles des boutons/labels vivent dans un fichier `.tres` de Theme, appliqué au nœud racine de chaque scène UI. Modifier l'apparence = ouvrir le Theme, pas chercher dans les scripts.

**Les popups et modals sont des scènes complètes.**
Pas de `add_child(preload(...))` dans un script obscur — chaque popup est une scène `.tscn` instanciée depuis un emplacement dédié dans le scene tree (`$UI/Popups/`).

### 6.2 Structure type d'une scène UI

```
BetUI (Control)
├── Background (NinePatchRect)        ← frame visuelle, éditable directement
├── BetAmountDisplay (HBoxContainer)
│   ├── Label ("Mise :")
│   └── BetValueLabel (Label)         ← mis à jour par le script via @onready
├── SliderContainer (VBoxContainer)
│   ├── MinBetButton (Button)
│   ├── BetSlider (HSlider)
│   └── MaxBetButton (Button)
└── ConfirmButton (Button)
```
Chaque nœud est nommé clairement, positionné dans l'éditeur, stylé via Theme. Le script attaché ne fait que brancher la logique sur les nœuds existants.

### 6.3 Ce qu'un script UI fait et ne fait pas

| ✅ Fait | ❌ Ne fait pas |
|---|---|
| `@onready` pour référencer les nœuds | Créer des nœuds UI dynamiquement |
| Mettre à jour le texte/couleur d'un Label | Définir des styles ou tailles |
| Émettre un signal sur input utilisateur | Contenir de la logique de jeu |
| Appeler une animation Tween | Calculer des valeurs de jeu |

---

## 7. Règles d'Or

1. **Avant d'ajouter une valeur dans le code, demande-toi si elle pourrait changer lors du balancing.** Si oui → Resource ou `game_rules.gd`.
2. **Un Manager = une responsabilité.** Si un script fait deux choses, c'est deux scripts.
3. **Les scènes UI n'ont pas de logique de jeu.** Elles affichent ce qu'on leur donne et émettent des inputs utilisateur — c'est tout.
4. **Toujours créer le `.tres` template avant les instances.** Dupliquer un template > créer de zéro.
5. **Les effets d'Echoes et Mutations ne sont jamais hardcodés dans la bataille.** Le BattleManager écoute les triggers, les Resources décrivent les effets.
6. **Tout élément UI est visible dans le scene tree.** Si tu ne peux pas le voir dans l'éditeur sans lancer le jeu, c'est mal fait.
