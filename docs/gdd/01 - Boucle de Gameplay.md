# 01 — Boucle de Gameplay (The Loop)

## 1.1 Macro-Structure (La Dive)

La Dive (Plongée) est divisée en **Depths** (profondeurs), chacun contenant 4 zones de jeu contre une Entité.

```
Arriver sur une Depth
  → Choisir sa mise (X Salt)
    → Tirer ses cartes (Hit, Stand ou Double)
      → Dealer révèle son jeu
        → Résultat :
            Gagné        → Entité perd Mise × PRSR / Joueur récupère sa mise
            21 au tirage → Entité perd (Mise × PRSR) × 1.5 / Joueur récupère sa mise
            Blackjack    → Entité perd (Mise × PRSR) × 2 / Joueur récupère sa mise (2 cartes = 21)
            Perdu / Bust → Perte de la mise
            Push         → Mise remboursée, PRSR conservée
  → Répéter jusqu'à mort de l'Entité ou 0 Salt
→ Récompense post-combat (Salt bonus OU boost PRSR de départ)
→ Shop (Gold Shells) → PRSR reset à 1.0 (ou valeur First Quarter si équipée)
→ Depth suivant, Entité plus dure
```

**Mort :** Tomber à 0 Salt = game over. Recommencer depuis le début (roguelite permanent).

---

## 1.2 Micro-Structure (La Main)

1. **Phase de Mise** : Le joueur choisit combien de Salt il mise pour cette main.
2. **Phase de Tirage** : Le joueur reçoit 2 cartes. Il décide de tirer (Hit) ou de s'arrêter (Stand) autant de fois qu'il veut.
3. **Check de Bust** : Si la main dépasse 21 → Bust. Le joueur perd la mise immédiatement.
4. **Révélation du Dealer** : Si pas de Bust, le dealer révèle ses cartes selon ses règles fixes.
5. **Résolution** :
   - Joueur > Dealer, score < 21 → **Victoire** : entité perd `Mise × PRSR`, joueur récupère sa mise
   - Joueur = 21 au tirage (3+ cartes) → **21** : entité perd `Mise × PRSR × 1.5`, joueur récupère sa mise
   - Joueur = 21 en 2 cartes → **Blackjack** : entité perd `Mise × PRSR × 2`, joueur récupère sa mise
   - Dealer > Joueur → **Défaite** : perte de la mise
   - Égalité → **Push** : mise remboursée, 0 dégât, PRSR conservée
