// vfx/shaders/blob_entity.gdshader
// Blob rond centré — gradient #20E0FE → #E790FF → #FFEF72, bord organique animé.
shader_type canvas_item;

// Ratio largeur/hauteur du ColorRect — à synchroniser avec le .tscn
uniform float aspect   : hint_range(0.1, 5.0) = 3;
uniform float speed       : hint_range(0.0, 3.0) = 1;
uniform float wobble      : hint_range(0.0, 0.3) = 0.2;
uniform float softness    : hint_range(0.0, 0.3) = 0.004;
uniform float padding     : hint_range(0.0, 0.5) = 0.15;

uniform vec4 color_left  : source_color = vec4(0.125, 0.878, 0.996, 1.0); // #20E0FE
uniform vec4 color_mid   : source_color = vec4(0.906, 0.565, 1.0,   1.0); // #E790FF
uniform vec4 color_right : source_color = vec4(1.0,   0.937, 0.447, 1.0); // #FFEF72

void fragment() {
	// UV centré + padding pour éviter le clipping aux bords + correction d'aspect
	vec2 c = (UV - vec2(0.5, 0.5)) * (1.0 + padding * 2.0);
	vec2 s = vec2(c.x * aspect, c.y);

	float angle = atan(s.y, s.x);
	float dist  = length(s);

	// Déformation organique du rayon — plusieurs harmoniques
	float r = 0.47;
	r += sin(angle * 2.0  + TIME * speed * 0.70) * wobble * 0.55;
	r += sin(angle * 3.7  - TIME * speed * 1.10) * wobble * 0.30;
	r += sin(angle * 6.1  + TIME * speed * 0.50) * wobble * 0.15;
	r += sin(angle * 0.9  - TIME * speed * 0.35) * wobble * 0.25;

	float alpha = step(dist, r);

	// Gradient horizontal 3 stops
	vec3 grad;
	float t = UV.x;
	if (t < 0.5) {
		grad = mix(color_left.rgb, color_mid.rgb, t * 2.0);
	} else {
		grad = mix(color_mid.rgb, color_right.rgb, (t - 0.5) * 2.0);
	}

	COLOR = vec4(grad, alpha);
}
