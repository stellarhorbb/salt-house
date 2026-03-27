# Session — 29 mars 2026

## Objectifs accomplis

### Polish UI — Battle Scene
- Cards du shop : 165×235 → 200×285, container élargi à ±250
- `EntityInfo` repositionné en haut (aligné avec ZoneName/Turn du HUD, y=30)
- `EntityBlob` : canvas étendu vers le bas + uniform `padding` dans le shader pour éviter le clipping UV aux bords — solution définitive indépendante de la taille du rect
- Buttons Hit/Stand/Double/Stake : fond blanc + texte noir + hover gradient FFEF72→E790FF→20E0FE (GradientTexture2D + StyleBoxTexture)

### Polish UI — HUD
- Icônes lunes dans le MoonCardPanel (remplacement des labels texte "LAST QTR" etc.)
- `BottomRight` renommé `Deck`, cliquable (mouse_filter = STOP)

### Blood Moon — nouvelle Moon Card
- `MoonCardResource.EffectType.BLOOD_MOON` ajouté
- Signal `blood_moon_triggered` dans `SignalBus`
- `MoonCardManager.apply()` émet le signal au lieu d'un effet passif
- `DeckManager` : `get_sample(count)`, `remove_from_pool(card)`, `_removed_keys` persistant entre zones, `build_standard_deck()` filtre les cartes supprimées
- `ShopManager` : Blood Moon dans le pool (1/5)
- `shop_scene.gd` : flow complet — affichage de 8 `CardVisual` aléatoires, clic → suppression définitive → zone suivante
- `resources/moon_cards/blood_moon.tres` créé (icon à assigner après import Godot)

### Deck Inspector
- Clic sur le compteur de deck (bas-droite HUD) → modal plein écran
- 4 rangées (Diamonds, Hearts, Spades, Clubs), triées A→K
- CardVisuals chevauchés (-40px separation), animation cascade (stagger 40ms)
- Bouton ✕ pour fermer

## Fichiers modifiés
- `scripts/core/signal_bus.gd`
- `scripts/resources/moon_card_resource.gd`
- `scripts/managers/moon_card_manager.gd`
- `scripts/managers/deck_manager.gd`
- `scripts/managers/shop_manager.gd`
- `scripts/ui/shop_scene.gd`
- `scripts/ui/hud.gd`
- `scenes/battle/battle_scene.tscn`
- `scenes/shop/shop_scene.tscn`
- `scenes/hud/hud.tscn`
- `vfx/shaders/blob_entity.gdshader`
- `vfx/materials/blob_entity.tres`

## Fichiers créés
- `resources/moon_cards/blood_moon.tres`

## État du projet
Blood Moon fonctionnelle : achat, sélection de carte à supprimer (CardVisual colorés par famille), suppression persistante dans le run. Deck Inspector accessible depuis le HUD. UI combat et shop plus polishée.

## Prochaines étapes
- Système Echoes (shop + HUD + effets)
- Zone system (ZoneResource paramétrable, 3-4 zones de test)
- Game loop complète (enchaînement zones → boss → victoire)
- Thème Godot global (phase créative)
