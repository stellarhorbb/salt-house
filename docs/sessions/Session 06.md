## Objectifs accomplis

### Fix — Bag Inspector
- Bag Inspector affiche maintenant uniquement les cartes restantes dans la pioche (`_deck`), pas toutes les cartes du run
- `DeckManager.get_draw_pile()` ajouté — retourne `_deck.duplicate()`
- Ouverture via Tab maintenu (press → open, release → close) en plus du clic existant

### Design — États de Cartes
6 états définis, applicables sur n'importe quelle carte, un état max par carte :

| État | Effet |
|---|---|
| **Flexible** | Compte ±1 de sa valeur face |
| **Salée** | Main gagnante → vole X Salt flat supplémentaire |
| **Sous Pression** | Quand tirée → +X PRSR direct |
| **Dorée** | Main gagnante → génère X Gold Shells |
| **Fissurée** | Si bust avec elle en main → récupère X% de la mise |
| **Horizon** | Si dernière carte avant un Stand → +50% du Salt misé en bonus |

### Design — Cartes Alchimiques
Nouvelle famille de cartes de shop — distinctes des Moon Cards. Appliquent un état sur une carte du deck (sélection aléatoire au moment de l'achat) :

| Carte | État |
|---|---|
| **Sel** | Salée |
| **Soufre** | Fissurée |
| **Mercure** | Flexible |
| **Or** | Dorée |
| **Azoth** | Horizon |
| **Plomb** | Sous Pression |

### Design — Echoes
- Classification interne par **déclencheur** (pas par effet)
- 6 familles : Cas limites, Tempo, PRSR/risque, Économie, États de cartes, Combinaisons
- Types d'effets : +PRSR, +Salt, Protection, +Gold Shells
- Synergies entre Echoes et états de cartes identifiées (session dédiée à prévoir)

### Design — Structure du Shop
5 types d'items clairement séparés :
- **Moon Cards** — modificateurs fondamentaux de run
- **Cartes Alchimiques** — appliquent un état sur une carte du deck
- **Echoes** — passifs de combat
- **Pack de Cartes** — deck building
- **Bet Buttons** — boutons de mise spéciaux

### Design — Lunes spéciales
- Drowned Moon définie : récupère du Salt sur chaque bust, mais Salt pool de l'Entité ne diminue pas sur victoires normales
- Autres lunes spéciales (Super Moon, Eclipse…) : session dédiée

## Fichiers modifiés
- `scripts/managers/deck_manager.gd` — ajout `get_draw_pile()`
- `scripts/ui/hud.gd` — Bag Inspector sur Tab, utilise `get_draw_pile()`
- `docs/gdd/02 - Cartes & Deck.md` — section 2.5 États de Cartes
- `docs/gdd/04 - Outils du Joueur.md` — Echoes restructurés, section 4.3 Cartes Alchimiques, structure Shop

## État du projet
États de cartes et Cartes Alchimiques designés et documentés. Echoes classifiés par déclencheur. Structure du shop complète sur le papier. Pipeline de résolution des scores identifiée comme prochain défi technique (ResolverManager).

## Prochaines étapes
- Session Echoes — catalogue de 25 Echoes pour la démo
- ResolverManager — pipeline de résolution Salt/PRSR en étapes strictes
- Zone system + game loop complète
