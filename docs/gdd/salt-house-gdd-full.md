# Salt House — Game Design Document

*Version 0.1.0 — Pivot BJ System — Mars 2026*

---

## Statut des décisions

Les sections marquées `> ❓ DÉCISION` sont des points ouverts à trancher avant implémentation.
Les sections marquées `> ⚠️ BALANCING` sont des valeurs provisoires à ajuster en phase de test.

---

## 0. Identité & Univers

### 0.1 Titre

Le jeu s'appelle **Salt House**. Le sel comme économie, comme danger, comme profondeur. Une maison qu'on construit sous l'eau.

> ❓ DÉCISION — Conserver "Fathom" comme titre ou basculer définitivement sur "Salt House" ?

### 0.2 High Concept

> Un roguelite casino où tu joues au Blackjack contre une Entité, tu mises du Salt pour lui voler le sien, et tu construis un deck de cartes pour survivre le plus profond possible.

- **Références gameplay :** Balatro (deck building roguelite), Blackjack (mécanique centrale)
- **Références DA & ton :** Hollow Knight, FromSoftware, Cult of the Lamb (style visuel)
- **Genre :** Roguelite / Deck Builder / Casino
- **Moteur :** Godot 4.6
- **Plateforme :** PC (Steam)

### 0.3 Univers

Le jeu se déroule dans un univers marin mélancolique. La narration est environnementale et suggérée, jamais explicite. Pas de dialogue, pas de personnages actifs. Le monde existe à travers les noms des cartes, les descriptions des Echoes, et la progression visuelle des zones.

Ton : calme et pesant. La mer comme force indifférente, pas hostile. La peur du bust est aussi la peur d'aller trop loin.

Références émotionnelles : Hollow Knight, Dark Souls / Elden Ring, The Leftovers.

### 0.4 Ce qui différencie de Balatro

| Axe | Balatro | Salt House |
|---|---|---|
| Mécanique centrale | Former des mains de poker | Blackjack hit/stand |
| Adversaire | Score cible fixe | Dealer qui joue ses propres cartes |
| Dégâts | Score arbitraire × multiplicateurs | Mise × PRSR |
| Ressource centrale | Argent (scoring) | Salt (bankroll = vie + attaque + économie) |
| Tension principale | Construire le score parfait | Savoir quand s'arrêter |

### 0.5 Terminologie

| Terme générique       | Terme Salt House |
| --------------------- | ---------------- |
| Run                   | Dive             |
| Niveau                | Depth            |
| Round                 | Zone             |
| Monnaie               | Salt             |
| Relique passive       | Echo             |
| Modificateur de règle | Moon Card        |
| Consommable           | Shell            |
| Hub inter-runs        | The Shore        |
| Boutique              | Shop             |
| Ennemi                | Entité           |

---

## 1. Boucle de Gameplay (The Loop)

### 1.1 Macro-Structure (La Dive)

La Dive est divisée en **Depths**, chacun contenant un combat contre une Entité.

```
Arriver sur un Depth
  → Choisir sa mise (X Salt)
    → Tirer ses cartes (Hit ou Stand)
      → Dealer révèle son jeu
        → Résultat :
            Gagné → Dégâts à l'Entité = Mise × PRSR + recupére mise x2
            Perdu / Bust → Perte de la mise (+ effets éventuels)
            21 exact → Dégâts critiques × 2
  → Répéter jusqu'à mort de l'Entité ou 0 Salt
→ Récompense post-combat
→ Shop
→ Depth suivant, Entité plus dure
```

**Mort :** Tomber à 0 Salt = game over. Recommencer depuis le début (roguelite permanent).

### 1.2 Micro-Structure (La Main)

1. **Phase de Mise** : Le joueur choisit combien de Salt il mise pour cette main.
2. **Phase de Tirage** : Le joueur reçoit 2 cartes. Il décide de tirer (Hit) ou de s'arrêter (Stand) autant de fois qu'il veut.
3. **Check de Bust** : Si la main dépasse 21 → Bust. Le joueur perd la mise immédiatement.
4. **Révélation du Dealer** : Si pas de Bust, le dealer révèle ses cartes selon ses règles fixes.
5. **Résolution** :
   - Joueur > Dealer (sans bust) → **Victoire de main** : dégâts à l'Entité + récupération de la mise
   - Dealer > Joueur → **Défaite de main** : perte de la mise
   - Égalité → **Push** : mise remboursée, 0 dégât

> ❓ DÉCISION — En cas de Push, le PRSR accumulé cette main est-il conservé ou réinitialisé ?

---

## 2. Les Cartes & Le Deck

### 2.1 Composition du Deck

Un deck de **52 cartes** réparties en **4 familles** thématiques.

| Valeur | Nom standard | Valeur BJ |
|---|---|---|
| 2 à 10 | Valeur numérique | Valeur face |
| Valet (J) | Figure | 10 |
| Dame (Q) | Figure | 10 |
| Roi (K) | Figure | 10 |
| As (A) | As | 1 ou 11 (choix joueur) |

13 cartes par famille × 4 familles = 52 cartes.

### 2.2 Les 4 Familles

> ❓ DÉCISION — Noms et thèmes des 4 familles dans l'univers Salt House.

Propositions à trancher :

| # | Nom suggéré | Thème | Couleur accent |
|---|---|---|---|
| 1 | Abyssal | Profondeur extrême, vide | Noir/Violet |
| 2 | Corail | Vie sous-marine, croissance | Rouge/Orange |
| 3 | Marée | Flux et reflux, eau | Bleu |
| 4 | Tempête | Surface agitée, danger | Blanc/Gris |

Chaque famille a son propre thème de Moon Cards associé (voir section 4.2).

### 2.3 Gestion du Deck

- Le deck est mélangé au début de chaque combat.
- Les cartes tirées ne sont pas remises dans le deck avant la fin du combat (ou un effet spécifique).

> ❓ DÉCISION — Le deck est-il remélangé entre chaque main d'un même combat, ou continue-t-il à se vider ?

- Le deck se construit au fil du run via le Shop et les Shells.
- Le joueur peut retirer des cartes (via Broken Shell) pour affiner sa composition.

---

## 3. Les Mécaniques Centrales

### 3.1 La Mise

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

> ❓ DÉCISION — Y a-t-il une mise minimum obligatoire par main ? (Empêche le joueur de jouer "gratuit" à 1 Salt pour explorer la situation.)

> ⚠️ BALANCING — Ratio de mise recommandé vs Salt total à définir en test. Point de départ : mise max suggérée = 20-30% de la bankroll.

### 3.2 Le PRSR (Multiplicateur de Dégâts)

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

### 3.3 Le Salt (Bankroll)

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

> ❓ DÉCISION — Salt de départ au début d'une Dive ? (Point de départ suggéré : 100 Salt)

> ⚠️ BALANCING — Les prix du Shop doivent représenter 15-25% de la bankroll moyenne attendue à chaque zone. Courbe à calibrer en test.

**Principe de balancing :**
Un joueur correct accumule naturellement. Un joueur qui bust souvent s'appauvrit. Pas de mécanisme de soin/récupération d'HP — la seule "défense" est de ne pas perdre sa mise.

---

## 4. Les Outils du Joueur

### 4.1 Les Echoes (Passifs)

Modificateurs passifs équipés pour toute la durée d'un combat (ou de la Dive selon le type). L'équivalent des Jokers/Reliques.

Ils touchent des axes **spécifiques au système BJ** :

| Axe | Exemple d'effet |
|---|---|
| Familles | "Si ta main contient 3 Abyssal → PRSR +0.3 ce tour" |
| Hit bonus | "Chaque Hit donne +0.2 PRSR au lieu de +0.1" |
| Protection bust | "Un bust par combat est ignoré" |
| Mise | "Si tu mises 20+ Salt → PRSR ×1.5" |
| Valeurs | "Chaque As dans ta main → +0.1 PRSR" |
| Figures | "Si ta main contient 2 Figures → mise remboursée en cas de défaite" |
| Économie | "Main gagnante → +10% Salt bonus" |
| Streak | "3 mains gagnées consécutives → PRSR permanent +0.2 pour ce combat" |

**Ce que les Echoes ne font PAS :** modifier les valeurs numériques des cartes directement (trop proche de Balatro, crée de l'imprévisibilité négative dans un système où 21 est le plafond fixe).

**Slots :** Le joueur peut équiper jusqu'à X Echoes simultanément.

> ❓ DÉCISION — Nombre de slots d'Echoes maximum ? (Suggestion : 5, comme l'ancien système)

**Acquisition :** Via Dark Shell (choix parmi 3) ou directement au Shop.

> ⚠️ BALANCING — Catalogue d'Echoes complet à concevoir. Objectif démo : 25 Echoes distincts.

### 4.2 Les Moon Cards (Modificateurs de Run)

Les Moon Cards sont des modificateurs **permanents pour toute la run** — elles boostent les valeurs fondamentales du jeu. Pas des effets ponctuels : des amplificateurs de style de jeu.

**Grille 2×2 — Symétrie des 4 phases :**

|                | **Croissance** | **Sécurité** |
|----------------|----------------|--------------|
| **PRSR**       | Last Quarter   | First Quarter |
| **Salt**       | Full Moon      | New Moon     |

| Moon Card         | Levier              | Effet (niveau 1)                                        |
|-------------------|---------------------|---------------------------------------------------------|
| **First Quarter** | PRSR plancher       | PRSR de base = 1.25 au lieu de 1.00 (permanent run)     |
| **Last Quarter**  | PRSR par Hit        | +0.25 PRSR par carte tirée (au lieu de +0.1)            |
| **Full Moon**     | Salt volé           | +25% au Salt volé par victoire                          |
| **New Moon**      | Salt perdu          | Récupère 30% de la mise sur une main perdue ou bustée   |

**Lecture de la grille :**
- **First + Last Quarter** → tu construis ta PRSR plus vite et plus haut (axe offensif)
- **Full + New Moon** → tu gagnes plus sur les victoires, tu perds moins sur les défaites (axe économique)

**Combos notables :**
- Last Quarter + Full Moon = snowball agressif — PRSR explose, payout suit
- First Quarter + New Moon = run solide et safe — plancher haut, pertes amorties
- Last Quarter + New Moon = high risk / high survive — tu prends des risques mais tu t'en remets
- First Quarter + Full Moon = propre et rentable — gains réguliers sans nécessiter de hitter beaucoup

**Pas de plafond de mise.** Le joueur peut all-in à tout moment — c'est sa prise de risque. New Moon n'affecte pas la mise maximale (supprimé), il agit sur la récupération en cas de perte.

**Lunes spéciales (post-launch / Légendaires) :**
- **Blood Moon**, **Super Moon**, **Eclipse**… — effets plus puissants, rares, potentiellement risqués.
- Le système de rareté se construit naturellement : 4 phases de base = Commun, lunes spéciales = Rare/Légendaire.

**Acquisition :** Via Nacre Shell (choix parmi 2-3) ou au Shop.

> ⚠️ BALANCING — Valeurs niveau 1 à affiner en test : First Quarter +0.25 plancher / Last Quarter +0.25/hit / Full Moon +25% / New Moon 30% récupération.

> ❓ DÉCISION — Nombre de Moon Cards équipables simultanément ?

### 4.3 Les Shells (Consommables)

Achetés au Shop, utilisés entre les combats (ou pendant ?) pour modifier le deck ou l'équipement.

| Shell | Effet |
|---|---|
| **Dark Shell** | Ajoute un Echo au choix parmi 3 |
| **Striped Shell** | Ajoute une carte au deck (famille ou valeur au choix) |
| **Nacre Shell** | Choisir une Moon Card parmi 2-3 |
| **Broken Shell** | Retirer une carte du deck (nettoyer les grosses valeurs risquées) |

> ❓ DÉCISION — Les Shells sont-ils utilisables uniquement entre les combats (au Shop), ou aussi pendant un combat ?

> ❓ DÉCISION — Y a-t-il une limite au nombre de Shells stockés ?

---

## 5. Le Dealer (L'Entité)

### 5.1 Comportement du Dealer

L'Entité joue comme un dealer de Blackjack — règles fixes, pas de décisions stratégiques :
- **Révèle une carte face visible** au début de chaque main, avant la décision du joueur
- La deuxième carte du dealer reste face cachée jusqu'à la révélation complète
- Révèle toutes ses cartes et tire selon son seuil après le Stand ou Bust du joueur

> ❓ DÉCISION — Seuil du dealer : s'arrête à 17 (règle BJ classique) ou tire jusqu'à 21 ? Ou valeur variable par zone ?

L'Entité n'a pas de HP — elle a un **Salt pool**. C'est à la fois sa vie et le butin du joueur.

**Déroulement d'un combat :**
- Le combat dure jusqu'à ce que le Salt pool de l'Entité tombe à 0 (victoire), ou que le joueur tombe à 0 Salt (défaite).
- Chaque main gagnée vole `Mise × PRSR` Salt au pool de l'Entité — ce montant entre directement dans la bankroll du joueur.
- Chaque main perdue ou bustée détruit la mise du joueur (Salt sink). Le pool de l'Entité ne change pas.
- Le pool de l'Entité ne remonte jamais sauf effet de Mutation explicite.

**Exemple :**
- Entité : 200 Salt / Joueur mise 100 Salt
- Joueur tire 4 + 6 = 10, hitte → 10 (PRSR 1.0 → 1.5), score final 20
- Entité fait 17 → joueur gagne
- Joueur vole 100 × 1.5 = **150 Salt** à l'Entité
- Entité : 50 Salt restants / Joueur : +50 Salt net

**Archétypes de build qui en découlent :**
- *Aggro PRSR* — deck épuré (petites cartes via Broken Shell), on hitte à fond pour monter le PRSR
- *Safe bankroll* — PRSR de base élevé via Echoes, on stand tôt mais on gagne régulièrement
- *High stakes* — grosses mises, peu de mains, tout ou rien

### 5.2 Structure : Depths & Zones

La progression est découpée en zones thématiques, chacune contenant plusieurs Depths.

| Zone | Depths | Ambiance |
|---|---|---|
| The Surface | 1–4 | Lumineux, introductif |
| Sunlight Depths | 5–8 | Calme mais la pression monte |
| Twilight Depths | 9–12 | Obscurité croissante |
| Midnight Depths | 13–16 | Noir, hostile |
| Abyssal Depths | 17–20 | Étrange, cosmique |
| Hadal Depths | 21–24 | Extrême, quasi-incompréhensible |
| The Abyss | 25+ | Infini, scaling exponentiel |

> ⚠️ BALANCING — Table complète Salt pool Entité / composition deck dealer / nombre de mains nécessaires par Depth à définir.

**Scaling sur 24+ Depths :**
- Salt pool de l'Entité augmente par zone
- Composition du deck du dealer évolue (plus de grosses cartes → bust moins souvent)
- Mutations de plus en plus impactantes
- Nombre de mains nécessaires pour tuer augmente

> ❓ DÉCISION — Le deck du dealer est-il visible/connu du joueur, ou opaque ?

### 5.3 Système de Mutations

Chaque Entité peut avoir des **effets passifs** (Mutations) qui modifient les règles du combat.

Exemples (non définitifs) :

| Rareté | Nom | Effet |
|---|---|---|
| Commun | Cuirasse | "Si le dealer bust, il ne prend que 50% des dégâts" |
| Commun | Pression Basse | "Si tu mises moins de X Salt, le dealer inflige −10% dégâts" |
| Peu commun | Distorsion | "Les paires dans ta main comptent comme −1 chacune" |
| Peu commun | Contre-Courant | "Si tu stands en dessous de 16, perte de mise ×1.5" |
| Rare | Voile Noir | "L'Entité ne révèle pas sa première carte — tu joues sans information sur son jeu" |
| Rare | Marée Inversée | "21 exact → dégâts normaux (pas de critique)" |
| Épique | Siphon | "Chaque main gagnée → l'Entité récupère X Salt dans son pool" |

> ❓ DÉCISION — Les Mutations sont-elles tirées aléatoirement par Depth, ou assignées fixement par zone ?

> ❓ DÉCISION — Nombre de Mutations actives simultanément par Depth ? (Suggestion issue de l'ancien GDD : 0 au début, +1 tous les 4 Depths)

> ⚠️ BALANCING — Catalogue complet des Mutations à concevoir. Objectif démo : 10-15 Mutations.

---

## 6. Progression & Économie

### 6.1 Récompenses Post-Combat

Après chaque Entité vaincue (Salt pool à 0), le joueur reçoit :
1. Le **Salt résiduel** est déjà dans sa bankroll (volé main par main). Un bonus de fin de combat peut s'ajouter selon le PRSR moyen atteint.
2. Un choix parmi **3 récompenses aléatoires**

Types de récompenses :

| Type | Effet |
|---|---|
| Salt | Montant variable selon rareté |
| Echo | Un Echo au choix parmi ceux proposés |
| Moon Card | Une Moon Card proposée |
| Shell | Un ou plusieurs Shells |
| Carte de deck | Carte spéciale à ajouter au deck |

> ⚠️ BALANCING — Système de rareté des récompenses à définir (Common/Uncommon/Rare/Epic/Legendary).

### 6.2 Le Shop

Le Shop apparaît après chaque récompense de combat.

**Inventaire aléatoire (refresh à chaque visite) :**

| Slot | Contenu | Coût estimé |
|---|---|---|
| 1 Echo | Passif permanent | 20-50 Salt selon rareté |
| 1 Moon Card | Modificateur de règle | 25-60 Salt |
| 2-3 Shells | Consommables | 10-20 Salt chacun |
| 1-2 Cartes | À ajouter au deck | 15-30 Salt |

**Services permanents :**
- **Reroll** — 5 Salt (+5 par utilisation) — régénère l'inventaire du Shop
- **Retrait de carte** — X Salt — équivalent du Broken Shell si pas en stock

> ⚠️ BALANCING — Prix à calibrer pour que le joueur puisse se permettre 1 achat majeur OU 2-3 achats économiques par visite. Jamais tout acheter.

### 6.3 The Shore (Hub Inter-Dives)

Espace entre les Dives. Calme, suspendu, en contraste avec l'obscurité croissante des Depths.

> ❓ DÉCISION — The Shore est-il dans le scope de la démo ou post-launch ?

Fonctions potentielles :
- Déverrouillage de contenu méta-progressif entre les runs
- Crafting de consommables à partir de ressources récupérées
- Consultation du lore via les objets ramenés des Depths

---

## 7. Conditions de Victoire & Défaite

**Victoire :** Atteindre et compléter le Depth 24+ (Hadal Depths final) en tuant toutes les Entités.

**Défaite :** Tomber à 0 Salt — ruiné, game over. Recommencer depuis le début.

Pas de HP joueur. Pas d'attaque directe de l'Entité. La pression vient entièrement de la **gestion de bankroll** sur toute la durée du run.

> ❓ DÉCISION — Y a-t-il une condition de défaite alternative (ex: nombre de mains max par combat) pour éviter les situations de grinding à très petite mise ?

---

## 8. Direction Artistique

### 8.1 Style Visuel

Style **digital painting flat, handcrafted** — ni pixel art, ni vectoriel propre. Grammaire visuelle proche de Cult of the Lamb, adaptée à un univers marin mélancolique.

**Principes clés :**
- Silhouettes noires dominantes avec 1-2 couleurs d'accent par asset
- Brush légèrement imparfaite sur tous les assets — texture organique, pas de tracés vectoriels nets
- Contours blancs systématiques sur fond sombre — lisibilité à tous les Depths
- Palette de bleus s'assombrissant progressivement : The Surface est translucide et lumineux, Hadal Depths est presque noir
- UI et modals dans le même style — brush imparfaite sur frames, boutons, backgrounds
- Animations bouncées avec tweens (zéro frame-by-frame)

**Ce que le style évite :**
- Pixel art rétro CRT saturé
- Vectoriel propre et géométrique
- Illustration complexe à fort rendering (incompatible avec scope solo)

### 8.2 Table Visuelle par Famille

> ❓ DÉCISION — Palette de couleurs et symboles visuels pour chacune des 4 familles (à définir après choix des noms).

### 8.3 Inventaire Assets (Démo)

| Catégorie | Quantité | Priorité |
|---|---|---|
| Cartes de deck (dos + faces) | 52 cartes + 4 dos par famille | Haute |
| L'Entité | 1 forme abstraite (idle + révélation) | Haute |
| UI (table de jeu, barres, modals) | Set complet | Haute |
| Echoes | 25 icônes | Haute |
| Moon Cards | 12-16 illustrations | Moyenne |
| Shells | 4 icônes | Moyenne |
| Backgrounds par zone | 6 zones × 1 background | Moyenne |

### 8.4 Pipeline

Photoshop → PNG transparent (min 2× taille affichée) → Import Godot (Filter OFF pour les assets nets, ON selon besoin) → Tweens pour animations

---

## 9. Spécifications Techniques

### 9.1 Architecture Godot 4.6

```
Resources :
  CardResource.gd         — Famille, Valeur, Sprite, effets spéciaux éventuels
  EchoResource.gd         — Nom, Description, Trigger, Effet
  MoonCardResource.gd     — Nom, Description, Famille associée, Modificateur de règle
  ShellResource.gd        — Type, Effet, Sprite
  EntityResource.gd       — Salt pool, Seuil dealer, Deck composition, Mutations actives

Managers :
  DeckManager.gd          — Composition du deck joueur, draw, shuffle, retrait
  DealerDeckManager.gd    — Deck et logique du dealer
  BankrollManager.gd      — Salt courant, mises, gains/pertes
  PRSRManager.gd          — Calcul et accumulation du multiplicateur
  BattleManager.gd        — Machine à états : Mise → Tirage → Dealer → Résolution
  GameManager.gd          — Run state, Depth courant, progression globale
  ShopManager.gd          — Génération et gestion de l'inventaire Shop
```

> ❓ DÉCISION — Architecture de la communication entre systèmes : Signals Godot ou autoload singleton centralisé ?

### 9.2 Machines à États (BattleManager)

```
IDLE
  → BETTING        : Le joueur choisit sa mise
  → PLAYER_DRAW    : Phase de tirage (Hit / Stand)
  → BUST_CHECK     : Vérifie si > 21
  → DEALER_REVEAL  : Le dealer tire ses cartes
  → RESOLUTION     : Calcul Mise × PRSR, transfer Salt joueur ↔ pool Entité
  → COMBAT_END     : Entité morte ou Salt = 0
  → REWARD         : Écran de récompense
  → SHOP           : Boutique
```

---

## 10. Roadmap & Scope

### 10.1 Scope Démo

**DANS la démo :**
- 1 Dive complète jouable (The Surface → Hadal Depths, 6 zones, 24 Depths)
- 1 deck de 52 cartes avec les 4 familles
- 25 Echoes
- 12-16 Moon Cards (3-4 par famille)
- 4 types de Shells
- 1 Entité avec variations par zone (Mutations)
- 10-15 Mutations
- Shop fonctionnel
- Direction artistique complète

**HORS scope démo (post-launch) :**
- The Shore et son système de crafting méta-progressif
- Lore étendu et narration environnementale
- Entités distinctes visuellement par zone (vs skin par zone)
- Modes spéciaux / défis quotidiens
- 25+ Echoes supplémentaires
- Steam Achievements

### 10.2 Questions Ouvertes — Récapitulatif

- [ ] Titre définitif : Salt House ou Fathom ?
- [ ] Noms et thèmes des 4 familles
- [ ] Remélange du deck entre les mains d'un même combat ?
- [ ] Mise minimum par main
- [x] PRSR : accumulation sur tout le combat, reset entre chaque zone
- [ ] Push (égalité) : Pressure conservée ou réinitialisée ? (probablement conservée, cohérent avec l'accumulation)
- [ ] Salt de départ
- [ ] Seuil du dealer (17 classique, 21, ou variable)
- [ ] Deck du dealer : visible ou opaque pour le joueur ?
- [ ] Mutations : aléatoires ou fixes par Depth ?
- [ ] Nombre de Mutations actives simultanément par Depth
- [ ] Nombre de slots Echoes maximum
- [x] Moon Cards : grille 2×2 — PRSR (Last Quarter croissance / First Quarter sécurité) × Salt (Full Moon croissance / New Moon sécurité)
- [x] New Moon : récupère 30% de la mise sur perte (pas un % max bet — plafond de mise supprimé)
- [x] Pas de plafond de mise — le joueur peut all-in à tout moment
- [ ] Nombre de Moon Cards équipables simultanément
- [ ] Valeurs exactes des bonus Moon Cards (⚠️ BALANCING — provisoire : FQ +0.25 plancher / LQ +0.25/hit / FM +25% / NM 30%)
- [ ] Shells utilisables en combat ou uniquement hors combat ?
- [ ] Limite de Shells stockés ?
- [ ] Condition de défaite alternative (nombre de mains max ?)
- [ ] The Shore : scope démo ou post-launch ?
- [x] Architecture signals vs singleton → Signals uniquement, managers autoloads
- [ ] Palette et symboles visuels des 4 familles
