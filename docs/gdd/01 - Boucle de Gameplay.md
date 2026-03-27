# 01 — Boucle de Gameplay (The Loop)

## 1.1 Macro-Structure (La Dive)

La Dive est divisée en **Depths**, chacun contenant un combat contre une Entité.

```
Arriver sur un Depth
  → Choisir sa mise (X Salt)
    → Tirer ses cartes (Hit ou Stand)
      → Dealer révèle son jeu
        → Résultat :
            Gagné → Dégâts à l'Entité = Mise × PRSR + récupère mise
            Perdu / Bust → Perte de la mise (+ effets éventuels)
            21 exact → Dégâts critiques × 2
  → Répéter jusqu'à mort de l'Entité ou 0 Salt
→ Récompense post-combat
→ Shop
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
   - Joueur > Dealer (sans bust) → **Victoire de main** : dégâts à l'Entité + récupération de la mise
   - Dealer > Joueur → **Défaite de main** : perte de la mise
   - Égalité → **Push** : mise remboursée, 0 dégât

> ❓ DÉCISION — En cas de Push, le PRSR accumulé cette main est-il conservé ou réinitialisé ?
