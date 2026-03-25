# Salt House — Instructions Claude

## Ritual de début de session

Avant toute chose, dans cet ordre :

1. Lire le log de la dernière session : `docs/sessions/` → fichier le plus récent
2. Lire les questions ouvertes : `docs/gdd/salt-house-gdd-full.md` → section **10.2**
3. Vérifier les derniers commits : `git log --oneline -10`

Cela suffit à se remettre dans le contexte exact sans demander au user de ré-expliquer.

---

## Le projet

**Salt House** — roguelite casino en Godot 4.6, cible Steam PC.
Mécanique centrale : Blackjack. Le joueur mise du Salt pour voler le Salt pool de l'Entité.

Fichiers clés :
- GDD complet → `docs/gdd/salt-house-gdd-full.md`
- Conventions & architecture → `docs/project-conventions.md`
- Logs de sessions → `docs/sessions/`

---

## Décisions de design verrouillées

Ces points sont tranchés — ne pas les remettre en question sans que le user le demande explicitement.

- **Salt pool** = HP de l'Entité. Main gagnée → joueur vole `Mise × PRSR`. Main perdue → mise disparaît (sink), pool Entité inchangé.
- **PRSR** s'accumule sur tout le combat (main après main). Reset à 1.0 entre chaque zone (après rewards + shop). PRSR base = 1.0 (sans hit = break-even).
- **Carte visible du dealer** avant la décision du joueur — règle de base, pas une option.
- **Pas de HP joueur** — le Salt est simultanément vie, attaque et monnaie.

---

## Conventions de développement

Référence complète : `docs/project-conventions.md`

Les points non-négociables :
- Toute valeur de balancing → `.tres` ou `game_rules.gd`. Zéro magic number dans le code.
- Communication entre systèmes → Signals uniquement. Jamais d'appel direct entre Managers.
- UI : tout nœud visible dans le scene tree. `@export` pour les valeurs visuelles. Pas de génération cachée par script.
- Un Manager = une responsabilité.

---

## Conventions Git

Format des commits : `type: description courte`

| Type | Usage |
|---|---|
| `build:` | Mise en place technique, architecture, scripts core |
| `feat:` | Nouvelle fonctionnalité de gameplay |
| `fix:` | Correction de bug |
| `design:` | Ajout ou modification d'assets, UI, DA |
| `content:` | Ajout de contenu (nouvelles cartes, echoes, mutations en .tres) |
| `docs:` | GDD, conventions, session logs, documentation |
| `balance:` | Modification de valeurs dans game_rules.gd ou .tres |

Règles :
- Court et concis — une ligne suffit le plus souvent
- Ne jamais mentionner Claude dans un commit
- Décrire ce qui a changé, pas comment

---

## Workflow Figma

Le MCP Figma est connecté (compte thom.spriet@gmail.com).
Quand le user partage une URL Figma → utiliser `get_design_context` pour lire le design directement.
Les assets (PNG, sprites) sont exportés manuellement par le user vers `res://assets/`.

---

## Fin de session

Toujours terminer par :
1. Remplir le log de session du jour dans `docs/sessions/`
2. Commiter les changements avec les bonnes conventions
