# scripts/ui/card_visual.gd
# Token/card visual — colored circle per family with value label at center.
# Size: 110×110px, white outside border 10px.
# Font: Londrina Solid (imported at res://assets/fonts/)
extends Control


const TOKEN_SIZE    := Vector2(110, 110)
const BORDER_WIDTH  := 10
const CORNER_RADIUS := 55  # = TOKEN_SIZE / 2 → perfect circle

@onready var _panel: Panel = $Panel
@onready var _label: Label = $Panel/Label


func setup(card: CardResource) -> void:
	custom_minimum_size = TOKEN_SIZE

	var style := StyleBoxFlat.new()
	style.bg_color = card.get_color()
	style.set_border_width_all(BORDER_WIDTH)
	style.border_color = Color.WHITE
	style.set_corner_radius_all(CORNER_RADIUS)

	_panel.add_theme_stylebox_override("panel", style)
	_label.text = card.display_name
