// vfx/shaders/wave_top.gdshader
// Vague animée en haut de l'écran — couleur au-dessus, transparent en dessous.
// 6 sinus à fréquences incommensurables pour un mouvement organique sans répétition visible.
shader_type canvas_item;

uniform float wave_y : hint_range(0.0, 1.0) = 0.78;
uniform float speed : hint_range(0.0, 5.0) = 0.35;
uniform float amplitude : hint_range(0.0, 0.3) = 0.10;
uniform vec4 color : source_color = vec4(1.0, 1.0, 1.0, 1.0);

void fragment() {
	float x = UV.x;
	float y = UV.y;

	float wave = sin(x * 1.7  + TIME * speed * 0.8 + 1.3) * amplitude * 0.55;
	wave += sin(x * 3.9  - TIME * speed * 1.1 + 0.7) * amplitude * 0.35;
	wave += sin(x * 6.2  + TIME * speed * 0.5 + 2.1) * amplitude * 0.20;
	wave += sin(x * 11.4 - TIME * speed * 1.7 + 0.4) * amplitude * 0.10;
	wave += sin(x * 17.8 + TIME * speed * 2.3 + 3.5) * amplitude * 0.05;
	wave += sin(x * 0.6  - TIME * speed * 0.3 + 1.9) * amplitude * 0.30;

	float edge = wave_y + wave;
	float blend = smoothstep(edge + 0.0005, edge - 0.0005, y);
	COLOR = vec4(color.rgb, blend * color.a);
}
