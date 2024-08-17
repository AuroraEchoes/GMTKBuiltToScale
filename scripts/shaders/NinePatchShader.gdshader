shader_type canvas_item;

uniform int margin_left;
uniform int margin_top;
uniform int margin_right;
uniform int margin_bottom;
uniform float scale;

void fragment() {
	vec2 sample_location = TEXTURE_PIXEL_SIZE / scale;
	COLOR = texture(TEXTURE, UV * sample_location);
	// Left side
	if (TEXTURE_PIXEL_SIZE.x * float(margin_left) >= UV.x)
		COLOR *= vec4(1.0, 0.5, 0.25, 1.0); 
	if (TEXTURE_PIXEL_SIZE.y * float(margin_bottom) >= UV.y) 
		COLOR *= vec4(0.25, 0.5, 1.0, 1.0);
	if (1.0 - (TEXTURE_PIXEL_SIZE.x * float(margin_right)) <= UV.x) 
		COLOR *= vec4(0.5, 1.0, 0.25, 1.0);
	if (1.0 - (TEXTURE_PIXEL_SIZE.x * float(margin_right)) <= UV.x) 
		COLOR *= vec4(0.5, 1.0, 0.25, 1.0);
}
