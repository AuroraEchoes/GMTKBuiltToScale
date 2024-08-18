shader_type canvas_item;

uniform float amount;

void fragment() {
	vec4 tex = texture(TEXTURE, UV);

	COLOR = mix(tex, vec4(0.0, 0.0, 0.0, 1.0 * tex.a), amount);
}