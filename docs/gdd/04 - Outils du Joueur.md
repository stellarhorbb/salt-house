# 04 — Les Outils du Joueur

## 4.1 Les Echoes (Passifs)

Modificateurs passifs équipés pour toute la durée d'un combat (ou de la Dive selon le type). L'équivalent des Jokers/Reliques.

**Classification interne par déclencheur** — 6 familles :

| Famille | Déclencheurs |
|---|---|
| **Cas limites** | Push, 21 au tirage, blackjack naturel, all-in, bust |
| **Tempo** | Vitesse de zone, nombre de mains, streaks de victoires |
| **PRSR / risque** | Hits, mains longues, stands risqués, valeurs de main spécifiques |
| **Économie** | Gold Shells en stock, dépenses au shop, génération en combat |
| **États de cartes** | Horizon, Fissurée, Salée, Sous Pression, Dorée, Flexible |
| **Combinaisons** | Paires, brelans, cartes de même famille, mains composées de figures |

**Types d'effets possibles** (orthogonaux aux familles) : +PRSR, +Salt, Protection (mise remboursée, bust amorti, perte réduite), +Gold Shells.

**Ce que les Echoes ne font PAS :** modifier les valeurs numériques des cartes directement (trop proche de Balatro, crée de l'imprévisibilité négative dans un système où 21 est le plafond fixe).

**Slots :** Le joueur peut équiper jusqu'à **5 Echoes simultanément**. Ce maximum peut être modifié par certains Echoes, classes ou effets spéciaux.

**Acquisition :** Via Pack d'Echoes au Shop (choix parmi 3-5) ou en achat unitaire direct au Shop.

> ⚠️ BALANCING — Catalogue d'Echoes complet à concevoir. Objectif démo : 25 Echoes distincts.

---

## 4.2 Les Moon Cards (Modificateurs de Run)

Les Moon Cards sont des modificateurs **permanents pour toute la run** — elles boostent les valeurs fondamentales du jeu. Pas des effets ponctuels : des amplificateurs de style de jeu.

**Grille 2×2 — Symétrie des 4 phases :**

|                | **Croissance** | **Sécurité** |
|----------------|----------------|--------------|
| **PRSR**       | Last Quarter   | First Quarter |
| **Salt**       | Full Moon      | New Moon     |

| Moon Card         | Levier       | Effet (niveau 1)                                        |
| ----------------- | ------------ | ------------------------------------------------------- |
| **First Quarter** | base PRSR    | PRSR de base = 1.25 au lieu de 1.00 (permanent run)     |
| **Last Quarter**  | PRSR per Hit | +0.2 PRSR par carte tirée (au lieu de +0.1)             |
| **Full Moon**     | Salt volé    | +10% au Salt volé par victoire                          |
| **New Moon**      | Salt perdu   | Récupère 5% de la mise sur une main perdue (bust exclu) |

**Lecture de la grille :**
- **First + Last Quarter** → tu construis ta PRSR plus vite et plus haut (axe offensif)
- **Full + New Moon** → tu gagnes plus sur les victoires, tu perds moins sur les défaites (axe économique)

**Combos notables :**
- Last Quarter + Full Moon = snowball agressif — PRSR explose, payout suit
- First Quarter + New Moon = run solide et safe — plancher haut, pertes amorties
- Last Quarter + New Moon = high risk / high survive — tu prends des risques mais tu t'en remets
- First Quarter + Full Moon = propre et rentable — gains réguliers sans nécessiter de hitter beaucoup

**Pas de plafond de mise.** Le joueur peut all-in à tout moment.

**Lunes spéciales (post-launch / Légendaires) :**
- **Blood Moon** — supprime définitivement une carte du deck (déjà implémentée)
- **Drowned Moon** — récupère du Salt sur chaque bust, mais le Salt pool de l'Entité ne diminue pas sur les victoires normales
- Autres à concevoir (Super Moon, Eclipse…) — effets radicaux, session dédiée

**Acquisition :** Via Pack de Moon Cards au Shop (présente 2 cartes, en choisir 1) ou en achat unitaire direct au Shop.

**Consommation immédiate :** une Moon Card acquise est appliquée instantanément et de façon permanente pour la run. Il n'y a pas de slots d'équipement — les effets s'accumulent au fil des achats.

> ⚠️ BALANCING — Valeurs niveau 1 : FQ +0.25 plancher / LQ +0.25/hit / FM +25% / NM 30% récupération.

---

## 4.3 Les Cartes Alchimiques

Deuxième famille de cartes de shop — distinctes des Moon Cards. Là où les Moon Cards modifient les valeurs globales de la run, les Cartes Alchimiques **appliquent un état sur une carte du deck**.

À l'achat, le joueur choisit une carte parmi une sélection aléatoire de son deck, et l'état s'applique définitivement.

| Carte | État appliqué |
|---|---|
| **Sel** | *Salée* — main gagnante → vole X Salt flat supplémentaire |
| **Soufre** | *Fissurée* — bust avec elle en main → récupère X% de la mise |
| **Mercure** | *Flexible* — compte ±1 de sa valeur face |
| **Or** | *Dorée* — main gagnante → génère X Gold Shells |
| **Azoth** | *Horizon* — dernière carte avant un Stand → +50% du Salt misé en bonus |
| **Plomb** | *Sous Pression* — quand tirée → +X PRSR direct |

**Acquisition :** vendues à l'unité au Shop (prix accessible), ou dans un pack dédié.

> ❓ DÉCISION — Nombre de cartes proposées au choix lors de l'application (3 cartes aléatoires du deck ?)

---

## 4.5 Les Bet Buttons

Les Bet Buttons sont les boutons de mise du joueur — à la fois interface et **objet de build roguelite**.

### Structure

- **5 slots au total** : 4 slots personnalisables + 1 slot ALL-IN épinglé (toujours présent, ne peut pas être retiré)
- Le slot ALL-IN est la soupape de secours — sans lui, un joueur à faible Salt pourrait se retrouver bloqué

### Buttons de départ (par classe)

Chaque classe démarre avec son propre panier de 4 buttons. Exemples :
- *Classe standard* : 10% / 25% / 50% / 75%
- *Classe agressive* : 25% / 50% / 75% / 99%
- *Classe conservatrice* : 5% / 10% / 25% / 50%

### Button Packs

Achetés au Shop, les Button Packs permettent d'ajouter ou remplacer un button dans les slots personnalisables (hors ALL-IN) :
- **Slot occupé** → le nouveau button remplace l'ancien (au choix du joueur)
- **Slot vide** → le button s'ajoute directement (possible si une classe démarre avec moins de 4 buttons)

**Buttons à valeur spéciale :**

| Button | Effet |
|---|---|
| **33% Button** | Mise exactement 1/3 du Salt |
| **99% Button** | Mise 99% du Salt — garde 1% en réserve |
| **Flat 10 Button** | Mise fixe de 10 Salt, indépendamment du total |
| **Mirror Button** | Mise = Salt pool de l'Entité ÷ 10 (arrondi) |

**Buttons à effet spécial :**

| Button | Effet |
|---|---|
| **Salt Button** | 10% de mise, mais +5% Salt bonus si la main est gagnée |
| **Crescendo Button** | Mise = mise précédente × 1.5 (démarre à 10% au premier tour) |
| **Minimum Button** | Mise fixe à 1 Salt — synergise avec des Echoes qui amplifient les petites mises |
| **Gambler's Button** | 50% de mise, mais PRSR +0.3 si gagné, -0.1 si perdu |
| **Tide Button** | Mise proportionnelle au Salt pool restant de l'Entité — monte en fin de combat |

> ⚠️ BALANCING — Catalogue complet à enrichir. Les buttons à effet spécial sont peu nombreux pour l'instant — session dédiée à prévoir.

> ❓ DÉCISION — Peut-on avoir plusieurs fois le même button dans ses slots ?

### Acquisition

Via **Button Packs** achetés au Shop, ou comme récompense de zone rare.

---

## 4.6 Les Boosters (Packs)

Achetés au Shop en **Gold Shells**, les Boosters sont des packs au contenu aléatoire. Après achat, le joueur choisit parmi les propositions du pack. Il n'y a pas de stock — les boosters sont ouverts immédiatement à l'achat.

**Structure du Shop — 5 types d'items :**

| Item | Type | Description |
|---|---|---|
| **Moon Cards** | Fondamental | Modificateurs globaux de run (Full, New, First, Last Quarter + spéciales) |
| **Cartes Alchimiques** | Amélioration | Appliquent un état sur une carte du deck (Sel, Soufre, Mercure, Or, Azoth, Plomb) |
| **Echoes** | Passif | Modificateurs de combat classés par déclencheur |
| **Pack de Cartes** | Deck building | Cartes normales ou avec état à ajouter au deck |
| **Bet Buttons** | Interface/build | Boutons de mise spéciaux |

**Packs disponibles :**

| Booster | Contenu | Choix |
|---|---|---|
| **Pack d'Echoes** | 3-5 Echoes aléatoires | Choisir 1 |
| **Pack de Moon Cards** | 2 Moon Cards aléatoires | Choisir 1, appliquée immédiatement |
| **Pack de Cartes** | Cartes normales ou avec état | Choisir 1 à ajouter au deck |
| **Pack de Bet Buttons** | 1 Bet Button aléatoire | Ajouté directement aux slots |
