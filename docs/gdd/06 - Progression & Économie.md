# 06 — Progression & Économie

## 6.1 Les Gold Shells

Les **Gold Shells** sont la monnaie exclusive du Shop. Elles sont complètement séparées du Salt — le Salt reste pur (mise / vie / vol en combat), les Gold Shells ne servent qu'à acheter au Shop.

**Acquisition post-combat :**

| Condition | Gold Shells |
|---|---|
| Base (toute victoire) | +8 |
| Bonus — victoire en < 3 mains | +4 |
| Bonus — victoire en < 5 mains | +2 |

Les deux bonus sont exclusifs — seul le meilleur s'applique. Maximum possible : 12 Gold Shells par combat.

> ❓ DÉCISION — Les Gold Shells s'accumulent-elles entre les zones, ou reset à chaque Shop ?

---

## 6.2 Récompenses Post-Combat

Après chaque Entité vaincue, le joueur choisit **1 récompense parmi 2** :

| Option | Effet |
|---|---|
| **Salt bonus** | % du Salt actuel du joueur (variable selon rareté) |
| **Boost PRSR de départ** | Augmente la PRSR de base pour le prochain combat uniquement |

Le Reward Screen ne donne **que** ces deux types — aucun item, Echo ou Moon Card. Tout le reste s'achète au Shop en Gold Shells.

**Rarités (affectent la valeur du Salt bonus ou l'intensité du boost PRSR) :**
| Rareté | Probabilité | Couleur |
|---|---|---|
| Common | 50% | #343536 |
| Uncommon | 30% | #707caa |
| Rare | 15% | #204ef4 |
| Legendary | 5% | #f1a21a |

> ⚠️ BALANCING — Valeurs exactes du Salt bonus % et des boost PRSR de départ à définir au playtest.

---

## 6.3 Le Shop

Le Shop apparaît après chaque écran de récompense. Tout s'achète en **Gold Shells**.

**Structure de l'inventaire (refresh à chaque visite) :**

Le Shop présente deux zones distinctes, générées aléatoirement :

| Zone | Contenu | Description |
|---|---|---|
| **Packs** (2-4 slots) | Pack d'Echoes / Pack de Moon Cards / Pack de Cartes / Pack de Bet Buttons | Contenu opaque — tu choisis dans le pack après achat |
| **Items unitaires** (2-3 slots) | Echo, Moon Card, Carte de deck, ou Bet Button | Contenu visible — tu sais exactement ce que tu achètes |

**Prix des items :**

| Type | Coût |
|---|---|
| Item Common | 4 Gold Shells |
| Item Uncommon | 5-6 Gold Shells |
| Item Rare / Pack | 7-8 Gold Shells |

**Services permanents :**
- **Reroll** — régénère l'inventaire complet (Packs + Items unitaires)
- **Retrait de carte** — X Gold Shells — permet de retirer une carte du deck (nettoyage)

**Coût des rerolls (suite de Fibonacci) :**

| Reroll | Coût | Total cumulé |
|---|---|---|
| 1er | 2 | 2 |
| 2ème | 3 | 5 |
| 3ème | 5 | 10 |
| 4ème | 8 | 18 — impossible sans bonus |

Avec 8 shells de base : 2 rerolls max confortablement. Le 3ème vide entièrement le budget avec le meilleur bonus (12 shells). Le 4ème est hors de portée sauf cas extrêmes.

**Les Gold Shells s'accumulent sur toute la run** — elles ne sont jamais réinitialisées entre les zones.

Cela ouvre un axe stratégique : dépenser au shop vs conserver pour déclencher des effets d'Echoes liés au nombre de Gold Shells détenues.

**Famille d'Echoes "Gold Shells" (à concevoir) :**
- Effets passifs basés sur le nombre de Gold Shells en stock
- Génération de Gold Shells en combat (ex: +1 par victoire de main)
- Conversion Gold Shells ↔ Salt ou PRSR

> ⚠️ BALANCING — Valeurs à affiner au playtest.

---

## 6.3 The Shore (Hub Inter-Dives)

Espace entre les Dives. Calme, suspendu, en contraste avec l'obscurité croissante des Depths.

> ❓ DÉCISION — The Shore est-il dans le scope de la démo ou post-launch ?

Fonctions potentielles :
- Déverrouillage de contenu méta-progressif entre les runs
- Crafting de consommables à partir de ressources récupérées
- Consultation du lore via les objets ramenés des Depths
