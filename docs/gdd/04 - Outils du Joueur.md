# 04 — Les Outils du Joueur

## 4.1 Les Echoes (Passifs)

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

**Familles d'Echoes identifiées :**
- **Cas limites** — push, 21 tiré, all-in
- **Tempo** — vitesse de zone, nombre de turns (ex: zone vidée en ≤5 turns → bonus Salt)
- **PRSR / risque** — amplifier les hits, les mains longues

**Ce que les Echoes ne font PAS :** modifier les valeurs numériques des cartes directement (trop proche de Balatro, crée de l'imprévisibilité négative dans un système où 21 est le plafond fixe).

**Slots :** Le joueur peut équiper jusqu'à X Echoes simultanément.

> ❓ DÉCISION — Nombre de slots d'Echoes maximum ? (Suggestion : 5)

**Acquisition :** Via Dark Shell (choix parmi 3) ou directement au Shop.

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
- **Blood Moon**, **Super Moon**, **Eclipse**… — effets plus puissants, rares, potentiellement risqués.

**Acquisition :** Via Nacre Shell (choix parmi 2-3) ou au Shop.

> ❓ DÉCISION — Nombre de Moon Cards équipables simultanément ?

> ⚠️ BALANCING — Valeurs niveau 1 : FQ +0.25 plancher / LQ +0.25/hit / FM +25% / NM 30% récupération.

---

## 4.3 Les Bet Buttons

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

Achetés au Shop, les Button Packs permettent de remplacer un button existant (hors ALL-IN) par un button spécial.

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

> ❓ DÉCISION — Les Button Packs remplacent-ils ou s'ajoutent-ils (jusqu'au max de 4) ?

### Acquisition

Via **Button Packs** achetés au Shop, ou comme récompense de zone rare.

---

## 4.4 Les Shells (Consommables)

Achetés au Shop, utilisés entre les combats (ou pendant ?) pour modifier le deck ou l'équipement.

| Shell | Effet |
|---|---|
| **Dark Shell** | Ajoute un Echo au choix parmi 3 |
| **Striped Shell** | Ajoute une carte au deck (famille ou valeur au choix) |
| **Nacre Shell** | Choisir une Moon Card parmi 2-3 |
| **Broken Shell** | Retirer une carte du deck (nettoyer les grosses valeurs risquées) |

> ❓ DÉCISION — Les Shells sont-ils utilisables uniquement entre les combats (au Shop), ou aussi pendant un combat ?

> ❓ DÉCISION — Y a-t-il une limite au nombre de Shells stockés ?
