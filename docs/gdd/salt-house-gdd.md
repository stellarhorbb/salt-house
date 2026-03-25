# Fathom — BJ System Game Design

*Issu d'une session d'idéation — 24 Mars 2026*

---

## Pourquoi ce pivot

La version précédente de Fathom avait une résolution trop complexe (Phase A/B/C, slots positionnels, ATK/DEF/PRSR) — trop de variables à tracker mentalement pour le joueur. L'idée originale de Fathom vient du Blackjack : **savoir quand s'arrêter**. Ce système revient à cette intuition de base tout en gardant l'ADN roguelite.

---

## Identité du jeu

> Un roguelite casino où tu joues au Blackjack contre une Entité, tu mises du Salt pour faire des dégâts, et tu construis un deck de cartes pour survivre le plus profond possible.

**Ce qui différencie de Balatro :**
- Le duel asymétrique : toi vs le dealer qui joue ses propres cartes
- La mise comme mécanique de dégâts : pas un score arbitraire
- La bankroll (Salt) comme unique ressource qui fait tout : offensive, défensive, économique
- Le sac/deck custom avec des familles et des cartes modifiées
- La profondeur croissante comme structure de run

---

## Core Loop

```
Arriver sur une zone
  → Choisir sa mise (X Salt)
    → Tirer ses cartes (Hit ou Stand)
      → Dealer révèle son jeu
        → Résultat :
            Gagné → Dégâts à l'entité = Mise × PRSR
            Perdu/Bust → Perte de la mise + dégâts reçus éventuels
            21 exact → Dégâts critiques × 2
  → Répéter jusqu'à mort de l'entité ou game over
→ Shop entre les zones
→ Zone suivante, entité plus dure
```

---

## Les Cartes / Tokens

Un deck de **52 cartes** réparties en **4 familles** (à nommer selon l'univers Fathom — ex: Abyssal, Corail, Marée, Tempête).

- Valeurs : 2 à 10, Valet, Dame, Roi, As
- Figures (V/D/R) = valeur 10
- As = 1 ou 11 au choix du joueur
- **Pas de token HZD séparé** — le bust à 21 EST le danger

Le deck se construit au fil du run via le shop et les Shells.

---

## La Mise

Avant chaque main, le joueur choisit combien de Salt il mise.

| Résultat | Conséquence |
|---|---|
| Gagner (score > dealer sans bust) | +Mise × PRSR en dégâts à l'entité |
| Perdre (dealer > toi) | -Mise |
| Bust (>21) | -Mise |
| 21 exact | Dégâts critiques ×2 |
| Main gagnante rembourse ×2 | (effet Echo/Moon Card possible) |

**La mise = l'engagement.** Plus tu mises, plus tu peux faire de dégâts — mais plus tu risques de t'appauvrir.

---

## Le PRSR (Multiplicateur)

Le PRSR est le multiplicateur de dégâts. Il monte pendant le combat via :

- **Chaque Hit** au-delà des 2 cartes initiales → +0.1 PRSR ce tour
- **Familles** — 3 cartes de même famille dans la main → +0.X PRSR
- **Streaks de précision** — atteindre 19+ plusieurs mains de suite → PRSR permanent +0.X
- **Echoes** — modificateurs passifs qui font monter le PRSR selon conditions
- **Moon Cards** — boosts de PRSR liés à certaines familles ou situations
- **21 exact** — spike de PRSR en plus des dégâts critiques

**Formule de dégâts :**
`Dégâts = Mise × PRSR`

**La tension centrale :**
Tirer plus de cartes = plus de PRSR mais plus de risque de bust. Le hit/stand devient une décision risk/reward sur le multiplicateur, pas juste sur la valeur de la main.

---

## Le Salt (Bankroll)

Le Salt est **l'unique ressource** du jeu. Il fait tout :
- **Offensive** — miser pour faire des dégâts
- **Économique** — acheter au shop (Echoes, Moon Cards, Shells, cartes)
- **Condition de défaite** — tomber à 0 Salt = game over (ruiné)

**Sources de Salt :**
- Mains gagnées en combat (mise remboursée + gain)
- Jackpot à la mort d'une entité
- Certains Echoes et effets de Moon Cards

**Puits de Salt :**
- Mises perdues (bust ou défaite)
- Shop entre les zones

**Principe de balancing :**
Un joueur correct accumule naturellement. Un joueur qui bust souvent s'appauvrit. Les prix du shop représentent toujours 15-25% de la bankroll moyenne attendue à cette zone.

---

## Le Dealer (Entité)

L'entité joue comme un dealer de BJ — règles fixes, pas de décisions :
- Tire jusqu'à atteindre son seuil (21 dès le départ, fixe pour toutes les zones)
- A ses propres HP à faire tomber sur plusieurs mains
- Peut avoir des **effets passifs par zone** (mutations) :
  - "Si le dealer bust, il ne prend que 50% des dégâts"
  - "Les paires dans ta main comptent -1"
  - "Si tu mises moins de X, le dealer contre-attaque"

**Scaling sur 24+ zones :**
- HP de l'entité augmente
- Composition du deck du dealer évolue (plus de grosses cartes = bust moins souvent)
- Mutations de plus en plus impactantes
- Nombre de mains nécessaires pour tuer augmente

---

## Les Echoes

Modificateurs passifs équipés avant le combat — l'équivalent des Noobs/Jokers.

Ils touchent des axes **uniques au système BJ** :
- Réagir aux familles ("si ta main contient 3 Abyssal, PRSR +0.3")
- Modifier le hit ("chaque hit donne +0.2 PRSR au lieu de +0.1")
- Protéger du bust ("un bust par zone ignoré")
- Modifier les mises ("si tu mises 20+, PRSR ×1.5")
- Réagir aux valeurs paires/impaires, aux figures, aux As
- Modifier l'économie ("main gagnante = +10% Salt bonus")

**Ce qu'ils ne font PAS :** modifier les valeurs des cartes directement (trop proche de Balatro, crée de l'imprévisibilité négative dans un système où le 21 est le plafond).

---

## Les Moon Cards

Modificateurs de règles — pas de simples bonus de stats. Elles changent **comment tu joues**.

**Axes possibles :**
- Modifier les règles du 21 ("bust passe à 23 cette zone", "un bust ignoré")
- Modifier le comportement d'une famille ("les As de Corail valent toujours 11")
- Modifier le PRSR selon la famille ou la situation
- Effets sur les mises ("main gagnante rembourse ×2")
- Ajouter des cartes spéciales au deck

**Acquisition :** via les Nacre Shells au shop — tu choisis parmi 2-3 Moon Cards proposées.

**4 familles = 4 thèmes de Moon Cards** — chaque phase de lune renforce ou modifie une famille spécifique.

---

## Les Shells

Consommables achetés au shop, utilisés entre les zones pour modifier le deck :

- **Dark Shell** — ajoute un Echo au choix parmi 3
- **Striped Shell** — ajoute une carte au deck (famille ou valeur au choix)
- **Nacre Shell** — choisir une Moon Card parmi 2-3
- **Broken Shell** — retirer une carte du deck (nettoyer les grosses valeurs risquées)

---

## Condition de victoire / défaite

**Victoire :** Atteindre la profondeur maximale (zone 24+) en tuant toutes les entités.

**Défaite :** Tomber à 0 Salt — ruiné, impossible de miser, game over.

Pas de HP joueur. Pas d'entity ATK directe. La pression vient de la **gestion de bankroll** sur toute la durée du run.

---

## Ce qui disparaît de Fathom actuel

| Élément | Statut |
|---|---|
| Tokens ATK/DEF/MOD | Remplacés par cartes BJ 2-As |
| Token HZD | Remplacé par le bust naturel |
| HP joueur | Remplacé par la bankroll Salt |
| Entity ATK | Remplacé par perte de mise |
| Phase A/B/C résolution | Remplacé par flip de cartes BJ |
| Slots positionnels | Supprimés |
| Streaks de tokens | Remplacés par combos de familles |
| Base ATK / Base DEF | Supprimés |

## Ce qui reste

| Élément | Statut |
|---|---|
| Salt comme monnaie | Reste — devient aussi la bankroll |
| PRSR comme multiplicateur | Reste — central |
| Echoes | Restent — redesignés pour le BJ |
| Moon Cards | Restent — redesignées |
| Shells | Restent |
| Profondeur zone par zone | Reste |
| Sac/deck custom | Reste — devient deck de cartes BJ |

---

## Questions ouvertes

- [ ] Les 4 familles — noms et thèmes dans l'univers Fathom
- [ ] Valeurs exactes de PRSR par hit et par famille
- [ ] Salt de départ et ratio gain/perte par main
- [ ] Nombre de mains par entité (limite fixe ou variable ?)
- [ ] Deck du dealer — composition et évolution par zone
- [ ] Les Echoes — redesign complet du catalogue
- [ ] Les Moon Cards — 4 familles × X phases = catalogue à définir
- [ ] Mutations d'entité — liste des effets possibles
