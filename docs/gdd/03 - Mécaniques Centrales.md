# 03 — Les Mécaniques Centrales

## 3.1 La Mise

Avant chaque main, le joueur choisit combien de Salt il mise.

| Résultat | Conséquence joueur | Conséquence Entité |
|---|---|---|
| Gagner (score > dealer sans bust) | +Mise × PRSR (payout total, mise incluse) | −Mise × PRSR sur son Salt pool |
| Perdre (dealer ≥ joueur, sans bust joueur) | −Mise (disparaît) | Aucune |
| Bust (joueur > 21) | −Mise (disparaît) | Aucune |
| 21 exact (Natural ou construit) | +Mise × PRSR × 2 | −Mise × PRSR × 2 sur son Salt pool |
| Push (égalité) | Mise remboursée | Aucune |

**La mise = l'engagement.** Plus tu mises, plus tu voles de Salt à l'Entité — mais plus tu risques de t'appauvrir si tu bust ou perds.

**Important :** Le Salt perdu sur une main perdue ou bustée disparaît — il ne va pas dans le pool de l'Entité. Le pool de l'Entité ne fait que descendre, jamais monter (sauf effets de Mutation spécifiques).

> ❓ DÉCISION — Y a-t-il une mise minimum obligatoire par main ?

> ⚠️ BALANCING — Ratio de mise recommandé vs Salt total à définir en test.

---

## 3.2 Le PRSR (Multiplicateur de Dégâts)

Le PRSR détermine combien de dégâts une main gagnante inflige à l'Entité.

**Formule :** `Dégâts = Mise × PRSR`

Le PRSR monte pendant le combat via :

| Source | Effet |
|---|---|
| Chaque Hit (au-delà des 2 cartes initiales) | +0.1 PRSR ce tour |
| 3 cartes de même famille dans la main | +X PRSR (bonus famille) |
| Streak de précision (atteindre 19+ sur N mains consécutives) | +X PRSR permanent sur le combat |
| 21 exact | Spike PRSR en plus des dégâts critiques |
| Echoes | Bonus PRSR passifs selon conditions |
| Moon Cards | Modificateurs PRSR selon famille ou situation |

> ⚠️ BALANCING — Valeurs exactes : +PRSR par hit, +PRSR par combo famille, seuil de streak à définir.

**Cycle de vie du PRSR :**
- **S'accumule** tout au long d'un combat, main après main — il ne se remet jamais à zéro entre deux mains du même combat
- **Se remet à 1.0** entre chaque zone (après l'écran de récompense et le Shop)

Conséquence : les premières mains d'un combat sont prudentes (PRSR bas, gains modestes), les dernières mains sont explosives. Le joueur a intérêt à survivre longtemps dans un combat — chaque main gagnée en fin de combat vaut bien plus que les premières.

**La tension centrale :** Tirer plus de cartes = plus de PRSR mais plus de risque de bust. Le hit/stand est une décision risk/reward sur le multiplicateur, pas seulement sur la valeur de la main.

---

## 3.3 Le Salt (Bankroll)

Le Salt est **l'unique ressource** du jeu. Il remplace simultanément :
- Les HP joueur (tomber à 0 = game over)
- La monnaie offensive (miser = attaquer)
- La monnaie économique (acheter au Shop)

**Sources de Salt :**

| Source | Montant |
|---|---|
| Main gagnée en combat | Mise récupérée + gain éventuel |
| Jackpot à la mort d'une Entité | Fixe par zone + bonus PRSR |
| Effets d'Echoes et Moon Cards | Variable |

**Puits de Salt :**

| Puits | Montant |
|---|---|
| Mise perdue (bust ou défaite de main) | −Mise |
| Achats au Shop | Variable (Echoes, Moon Cards, Shells, cartes) |

> ❓ DÉCISION — Salt de départ au début d'une Dive ? (Point de départ actuel : 100 Salt)

> ⚠️ BALANCING — Les prix du Shop doivent représenter 15-25% de la bankroll moyenne attendue à chaque zone.

**Principe de balancing :**
Un joueur correct accumule naturellement. Un joueur qui bust souvent s'appauvrit. Pas de mécanisme de soin/récupération d'HP — la seule "défense" est de ne pas perdre sa mise.

**Règle de progression des Salt Pools — "One-Shot impossible" :**

> Le Salt Pool de chaque entité doit être supérieur au Salt maximum qu'un joueur pourrait accumuler en gagnant parfaitement toutes les zones précédentes.

Formule : `pool[N] > salt_départ + pool[1] + pool[2] + ... + pool[N-1]`

Conséquence : même un all-in ne suffit pas à effacer la zone suivante en une seule main — le joueur est structurellement obligé de jouer plusieurs mains, d'accumuler de la PRSR, et d'investir dans des Echoes pour rester compétitif.

Exemple de courbe respectant la règle (salt départ = 100) :

| Zone | Pool entité | Salt max joueur après |
|------|-------------|----------------------|
| 1    | 100         | 200                  |
| 2    | 250         | 450                  |
| 3    | 500         | 950                  |
| 4    | 1 000       | 1 950                |
| 5    | 2 000       | 3 950                |
| 6    | 4 000       | 7 950                |

Note : la règle s'applique à PRSR=1.0 (base). Avec PRSR élevée, le joueur vole plus par main — les Echoes et Moon Cards sont le levier conçu pour bridger cet écart, pas le salt brut.

---

## 3.4 Le Double Down

Le joueur peut doubler sa mise après avoir reçu ses 2 cartes initiales.

**Règles :**
- Disponible uniquement sur la main initiale (2 cartes) — pas après un Hit
- Salt suffisant → mise × 2 exact
- Salt insuffisant → mise + tout le Salt restant (all-in double)
- Une seule carte tirée après le double → résolution directe, pas de Hit/Stand
- Le bouton affiche **"DOUBLE"** ou **"ALL IN DOUBLE"** selon le Salt disponible

**Design :** Pas de récompense systématique au double dans les règles de base — le gain vient naturellement de la mise × PRSR augmentée. Les Echoes peuvent créer des builds orientés double.
