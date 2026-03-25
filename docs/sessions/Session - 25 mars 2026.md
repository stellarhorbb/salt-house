## Contexte
Première session sur le nouveau projet Salt House. Projet Godot vierge, bifurcation depuis l'ancien projet Fathom.

---

## Ce qu'on a fait

### 1. Analyse des deux GDD
- Lu et comparé l'ancien GDD Fathom (v0.1.0 — système tokens ATK/DEF/HZD, slots positionnels, phases A/B/C) avec le nouveau GDD pivot (BJ system)
- Verdict : pivot solide, le BJ simplifie radicalement la lisibilité et l'accessibilité du jeu

### 2. Création du GDD complet
- Créé `docs/gdd/salt-house-gdd-full.md` structuré comme l'ancien GDD
- Contenu : Identité, Core Loop, Mécaniques, Outils joueur, Entité, Économie, DA, Tech, Roadmap
- Questions ouvertes balisées `❓ DÉCISION`, valeurs de balancing balisées `⚠️ BALANCING`

### 3. Décisions de design prises

**Salt pool de l'Entité (= ses HP)**
- L'Entité n'a pas de HP — elle a un Salt pool
- Main gagnée → le joueur vole `Mise × PRSR` de son pool (payout total, mise incluse)
- Main perdue ou bustée → la mise disparaît (Salt sink), le pool de l'Entité ne change pas
- Le pool ne remonte jamais sauf effet de Mutation explicite
- Exemple validé : Entité 200 Salt / mise 100 / PRSR 1.5 → joueur vole 150, Entité à 50

**PRSR**
- S'accumule sur tout le combat (main après main), ne se reset PAS entre les mains
- Se remet à 1.0 entre chaque zone (après rewards + shop)
- PRSR = 1.0 à la base → sans hit, une main gagnée est break-even
- Chaque hit au-delà des 2 cartes initiales → +PRSR (valeur à balancer)

**Carte visible du dealer**
- L'Entité révèle une carte face visible avant la décision du joueur — règle BJ classique, intégrée comme règle de base (pas une option)
- La Mutation "Voile Noir" retire précisément cette information

**Archétypes de build identifiés**
- *Aggro PRSR* : deck épuré (petites cartes), on hitte à fond
- *Safe bankroll* : PRSR de base élevé via Echoes, on stand tôt
- *High stakes* : grosses mises, peu de mains, tout ou rien

### 4. Conventions & Architecture
- Créé `docs/project-conventions.md` avec :
  - Resource-driven design (tout en `.tres`, zéro valeur hardcodée)
  - Communication par Signals uniquement
  - Un Manager = une responsabilité
  - Structure complète des dossiers Godot
  - Squelettes de code pour CardResource, EchoResource, EntityResource, MutationResource
  - `game_rules.gd` pour toutes les constantes
  - Conventions UI : tout visible dans le scene tree, `@export` pour les valeurs visuelles, Theme `.tres`, pas de génération dynamique cachée

### 5. Setup technique
- Git initialisé, `.gitignore` Godot 4 créé
- Remote configuré sur `stellarhorbb/salt-house` (hello@horbb.com)
- Premier commit poussé sur `main`
- MCP Figma connecté et testé (compte thom.spriet@gmail.com) — workflow : URL Figma → lecture directe → implémentation Godot sans export manuel

---

## Questions ouvertes restantes (prioritaires)
- Titre définitif : Salt House ou Fathom ?
- Noms des 4 familles de cartes
- Salt de départ
- Seuil du dealer (17 classique ou autre)
- PRSR : valeur exacte par hit, par combo famille
- Deck remélangé entre les mains d'un même combat ?
- Nombre de slots Echoes maximum

---

## Prochaines étapes suggérées
1. Trancher les questions ouvertes prioritaires dans le GDD
2. Maquettes Figma des premières scènes UI
3. Poser l'architecture Godot (dossiers, premiers scripts core, game_rules.gd)
