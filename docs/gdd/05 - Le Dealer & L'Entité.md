# 05 — Le Dealer (L'Entité)

## 5.1 Comportement du Dealer

L'Entité joue comme un dealer de Blackjack — règles fixes, pas de décisions stratégiques :
- **Révèle une carte face visible** au début de chaque main, avant la décision du joueur
- La deuxième carte du dealer reste face cachée jusqu'à la révélation complète
- Révèle toutes ses cartes et tire selon son seuil après le Stand ou Bust du joueur

> ❓ DÉCISION — Seuil du dealer : s'arrête à 17 (règle BJ classique) ou valeur variable par zone/Mutation ?

L'Entité n'a pas de HP — elle a un **Salt pool**. C'est à la fois sa vie et le butin du joueur.

**Déroulement d'un combat :**
- Le combat dure jusqu'à ce que le Salt pool de l'Entité tombe à 0 (victoire), ou que le joueur tombe à 0 Salt (défaite).
- Chaque main gagnée vole `Mise × PRSR` Salt au pool de l'Entité — ce montant entre directement dans la bankroll du joueur.
- Chaque main perdue ou bustée détruit la mise du joueur (Salt sink). Le pool de l'Entité ne change pas.
- Le pool de l'Entité ne remonte jamais sauf effet de Mutation explicite.

**Exemple :**
- Entité : 200 Salt / Joueur mise 100 Salt
- Joueur tire 4 + 6 = 10, hitte → +10 (PRSR 1.0 → 1.1), score final 20
- Entité fait 17 → joueur gagne
- Joueur vole 100 × 1.1 = **110 Salt** à l'Entité
- Entité : 90 Salt restants / Joueur : +10 Salt net

**Archétypes de build qui en découlent :**
- *Aggro PRSR* — deck épuré (petites cartes via Broken Shell), on hitte à fond pour monter le PRSR
- *Safe bankroll* — PRSR de base élevé via Echoes, on stand tôt mais on gagne régulièrement
- *High stakes* — grosses mises, peu de mains, tout ou rien

> ❓ DÉCISION — Le deck du dealer est-il visible/connu du joueur, ou opaque ?

---

## 5.2 Structure : Depths & Zones

La progression est découpée en zones thématiques, chacune contenant plusieurs Depths.

| Zone            | Depths | Ambiance                        |
| --------------- | ------ | ------------------------------- |
| The Surface     | 1–4    | Lumineux, introductif           |
| Sunlight Depths | 5–8    | Calme mais la pression monte    |
| Twilight Depths | 9–12   | Obscurité croissante            |
| Midnight Depths | 13–16  | Noir, hostile                   |
| Abyssal Depths  | 17–20  | Étrange, cosmique               |
| Hadal Depths    | 21–24  | Extrême, quasi-incompréhensible |
| The Abyss       | 25+    | Infini, scaling exponentiel     |

> ⚠️ BALANCING — Table complète Salt pool Entité / composition deck dealer / nombre de mains nécessaires par Depth à définir.

**Scaling sur 24+ Depths :**
- Salt pool de l'Entité augmente par zone
- Composition du deck du dealer évolue (plus de grosses cartes → bust moins souvent)
- Mutations de plus en plus impactantes
- Nombre de mains nécessaires pour tuer augmente

---

## 5.3 Système de Mutations

Les Mutations sont le **principal levier de difficulté** du jeu. Elles modifient les règles du combat de manière cumulative et rendent le skill-only structurellement insuffisant à partir d'un certain seuil.

**Règle de déclenchement — tranchée :**
- Une nouvelle Mutation aléatoire s'active **tous les 4 zones** (zone 4, 8, 12, 16, 20, 24)
- Tirée aléatoirement depuis un pool global de Mutations
- Elle reste active pour tout le reste de la run
- À zone 24 : 6 Mutations actives simultanément

**Principe de design :**
Chaque Mutation est gérable seule. C'est leur **accumulation et leurs synergies** qui rendent la run progressivement impossible sans Echoes.

**Synergies volontaires — exemples :**

| Mutation A | Mutation B | Effet combiné |
|---|---|---|
| Marée Noire (bust = ×2) | Contre-Courant (stand < 18 = perte) | Obligation de viser 18-21 exactement |
| Siphon (entité récupère au win) | Cuirasse (bust = 50% dégâts) | L'entité est quasi-unkillable sans PRSR élevée |
| Marée Basse (blind montante) | Marée Noire (bust = ×2) | Pression économique + punition maximale du bust |

**Catalogue — premier jet (objectif démo : 15 Mutations) :**

*Catégorie A — Punition du bust :*
| Nom | Effet |
|---|---|
| Marée Noire | Bust → perd `2× mise` au lieu de `1×` |
| Abîme | Bust → l'Entité récupère `20%` de son pool |
| Fond Marin | Bust → PRSR réinitialisée à 1.0 |

*Catégorie B — Punition du stand :*
| Nom | Effet |
|---|---|
| Contre-Courant | Stand en dessous de 18 → mise perdue même en cas de victoire |
| Voile de Sel | Stand en dessous de 19 → dégâts réduits de 50% |

*Catégorie C — Résistance de l'Entité :*
| Nom | Effet |
|---|---|
| Cuirasse | L'Entité absorbe les 200 premiers Salt de dégâts par main |
| Siphon | Chaque main gagnée → l'Entité récupère `10%` de son pool |
| Carapace | Blackjack naturel → dégâts normaux (pas de ×2) |

*Catégorie D — Pression économique :*
| Nom | Effet |
|---|---|
| Marée Basse | Mise minimum = `15%` du salt actuel du joueur |
| Taxe Abyssale | Chaque main coûte `3%` du salt du joueur avant distribution |

*Catégorie E — Information cachée :*
| Nom | Effet |
|---|---|
| Voile Noir | La carte visible du dealer est retournée face cachée |
| Brouillard | Le score du dealer n'est pas affiché pendant le jeu du joueur |

> ⚠️ BALANCING — Valeurs exactes à calibrer. Objectif : 3 Mutations actives = difficile sans Echoes, 5+ = quasi-impossible.
