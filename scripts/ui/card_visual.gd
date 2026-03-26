# scripts/ui/card_visual.gd
# Token visuel d'une carte — cercle coloré par famille, valeur au centre.
# Taille : 110×110px, bordure blanche 10px.
extends Control

class_name CardVisual


const TOKEN_SIZE    := Vector2(110, 110)
const BORDER_WIDTH  := 10
const CORNER_RADIUS := 55  # = TOKEN_SIZE / 2 → cercle parfait

const HIDDEN_BG_COLOR     := Color(0.12, 0.12, 0.15)
const HIDDEN_BORDER_COLOR := Color(0.32, 0.32, 0.38)

@onready var _panel: Panel = $Panel
@onready var _label: Label = $Panel/Label


# Carte visible — avec animation de distribution
func setup(card: CardResource, deal_delay: float = 0.0) -> void:
	custom_minimum_size = TOKEN_SIZE
	_apply_card_style(card)
	_animate_deal_in(deal_delay)


# Carte cachée (hole card) — face down
func setup_hidden(deal_delay: float = 0.0) -> void:
	custom_minimum_size = TOKEN_SIZE
	_apply_hidden_style()
	_animate_deal_in(deal_delay)


# Révélation : flip horizontal → change le style → flip retour
func reveal(card: CardResource) -> void:
	var tween := create_tween().set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "scale:x", 0.0, 0.1)
	tween.tween_callback(_apply_card_style.bind(card))
	tween.tween_property(self, "scale:x", 1.0, 0.12)


# ── Styles ─────────────────────────────────────────────────────────────────────

func _apply_card_style(card: CardResource) -> void:
	var style := StyleBoxFlat.new()
	style.bg_color = card.get_color()
	style.set_border_width_all(BORDER_WIDTH)
	style.border_color = Color.WHITE
	style.set_corner_radius_all(CORNER_RADIUS)
	_panel.add_theme_stylebox_override("panel", style)
	_label.text = card.display_name


func _apply_hidden_style() -> void:
	var style := StyleBoxFlat.new()
	style.bg_color = HIDDEN_BG_COLOR
	style.set_border_width_all(BORDER_WIDTH)
	style.border_color = HIDDEN_BORDER_COLOR
	style.set_corner_radius_all(CORNER_RADIUS)
	_panel.add_theme_stylebox_override("panel", style)
	_label.text = "?"


# ── Animation ──────────────────────────────────────────────────────────────────

func _animate_deal_in(delay: float) -> void:
	modulate.a = 0.0
	scale = Vector2(0.75, 0.75)
	var tween := create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	if delay > 0.0:
		tween.tween_interval(delay)
	tween.tween_property(self, "scale", Vector2.ONE, 0.18)
	tween.parallel().tween_property(self, "modulate:a", 1.0, 0.15)
