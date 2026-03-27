# 08 — Direction Artistique

## 8.1 Style Visuel

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

---

## 8.2 Table Visuelle par Famille

> ❓ DÉCISION — Palette de couleurs et symboles visuels pour chacune des 4 familles (à définir après choix des noms en section 02).

---

## 8.3 Inventaire Assets (Démo)

| Catégorie | Quantité | Priorité |
|---|---|---|
| Cartes de deck (dos + faces) | 52 cartes + 4 dos par famille | Haute |
| L'Entité | 1 forme abstraite (idle + révélation) | Haute |
| UI (table de jeu, barres, modals) | Set complet | Haute |
| Echoes | 25 icônes | Haute |
| Moon Cards | 12-16 illustrations | Moyenne |
| Shells | 4 icônes | Moyenne |
| Backgrounds par zone | 6 zones × 1 background | Moyenne |

---

## 8.4 Pipeline

Photoshop → PNG transparent (min 2× taille affichée) → Import Godot (Filter OFF pour les assets nets, ON selon besoin) → Tweens pour animations
