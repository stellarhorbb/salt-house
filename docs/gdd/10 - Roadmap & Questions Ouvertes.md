# 10 — Roadmap & Questions Ouvertes

## 10.1 Scope Démo

**DANS la démo :**
- 1 Dive complète jouable (The Surface → Hadal Depths, 6 zones, 24 Depths)
- 1 deck de 52 cartes avec les 4 familles
- 25 Echoes
- 12-16 Moon Cards (3-4 par famille)
- 4 types de Boosters (Packs)
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

---

## 10.2 Questions Ouvertes

- [x] Titre définitif : Salt House ou Fathom ?
- [ ] Noms et thèmes des 4 familles
- [ ] Remélange du deck entre les mains d'un même combat ?
- [ ] Mise minimum par main
- [x] PRSR : accumulation sur tout le combat, reset entre chaque zone
- [x] Push (égalité) : PRSR conservée
- [x] 21 au tirage → dégâts × 1.5 / Blackjack naturel → dégâts × 2
- [x] Salt de départ — 100
- [ ] Seuil du dealer (17 classique, ou variable par zone/Mutation)
- [ ] Deck du dealer : visible ou opaque pour le joueur ?
- [x] Mutations : aléatoires, tirées d'un pool global, +1 tous les 4 zones
- [x] Nombre de Mutations actives simultanément : jusqu'à 6 à zone 24
- [x] Nombre de slots Echoes maximum — 5 (extensible via Echoes/classe)
- [x] Moon Cards : grille 2×2 — PRSR × Salt
- [x] New Moon : récupère X% de la mise sur perte contre le dealer uniquement (bust exclu)
- [x] Pas de plafond de mise
- [x] Moon Cards : consommées immédiatement à l'achat, pas de slots — effets s'accumulent
- [ ] Valeurs exactes des bonus Moon Cards (⚠️ BALANCING)
- [x] Shells supprimés — remplacés par les Boosters (4 types de packs)
- [x] Monnaie shop : Gold Shells — séparées du Salt, gagnées post-combat
- [x] Bonus d'efficacité : Gold Shells supplémentaires si combat terminé en peu de mains
- [x] Shop : mix de Packs (opaques) + Items unitaires (visibles), tout payé en Gold Shells
- [x] Reroll : coût en Gold Shells, escalade x2 (4 rerolls max naturellement)
- [x] Gold Shells : base 8 / bonus +4 si < 3 mains / bonus +2 si < 5 mains / max 12
- [x] Reroll : suite Fibonacci 2, 3, 5, 8 — 4ème reroll hors de portée sans bonus
- [x] Prix items : Common 4 / Uncommon 5-6 / Rare+Pack 7-8 Gold Shells
- [x] Gold Shells : accumulation sur toute la run (pas de reset)
- [ ] Condition de défaite alternative (nombre de mains max ?)
- [ ] The Shore : scope démo ou post-launch ?
- [x] Architecture signals vs singleton → Signals uniquement, managers autoloads
- [x] Reward Screen — Salt bonus % OU boost PRSR de départ uniquement, pas d'items
- [x] PRSR reset — après chaque Shop, retourne à 1.0 (ou valeur First Quarter si équipée)
- [x] Deck joueur — pas de limite de taille, full roguelike
- [x] Bet Buttons — slot vide = add / slot occupé = replace au choix
- [ ] Palette et symboles visuels des 4 familles
- [ ] Peut-on avoir plusieurs fois le même Bet Button dans ses slots ?
- [ ] Catalogue complet des Bet Buttons spéciaux (session dédiée)
- [ ] Catalogue des cartes spéciales (familles d'effets à concevoir)
