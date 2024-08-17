// Heavily based on this tutorial: https://www.febucci.com/2019/06/sprite-outline-shader/

shader_type canvas_item;

uniform vec4 color: source_color;
uniform bool enabled;
uniform float pulse_speed;
uniform float overlay_max_alpha;

void fragment() {
	if (enabled) {
		float percent_overlay = 0.5 * overlay_max_alpha * sin((1.0 / pulse_speed) * PI * TIME) + (overlay_max_alpha / 2.0);
	COLOR = mix(texture(TEXTURE, UV), color, percent_overlay);
	}
}