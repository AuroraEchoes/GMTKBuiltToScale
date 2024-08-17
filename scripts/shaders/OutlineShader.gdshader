// Heavily based on this tutorial: https://www.febucci.com/2019/06/sprite-outline-shader/

shader_type canvas_item;

uniform vec4 outline_color: source_color;
uniform int stroke_width;
uniform bool enabled;

float alpha_at_point(vec2 direction, int tiles, sampler2D tex, vec2 uv, vec2 texel_size) {
	return texture(tex, uv + (texel_size * direction * float(tiles))).a;
}

bool within_border(sampler2D tex, vec2 uv, vec2 texel_size) {
	for (int i = 0; i < stroke_width; i++)
	{
		if (alpha_at_point(vec2(1, 0), i, tex, uv, texel_size) < 0.25) return true;
		if (alpha_at_point(vec2(-1, 0), i, tex, uv, texel_size) < 0.01) return true;
		if (alpha_at_point(vec2(0, 1), i, tex, uv, texel_size) < 0.01) return true;
		if (alpha_at_point(vec2(0, -1), i, tex, uv, texel_size) < 0.01) return true;
	}
	return false;
}

void fragment() {
	//if (within_border(TEXTURE, UV, TEXTURE_PIXEL_SIZE) && enabled) {
		//COLOR = outline_color;
	//}
	//COLOR.a = texture(TEXTURE, UV + vec2(1.0)).a;
	if (UV.x <= SCREEN_PIXEL_SIZE.x * float(stroke_width)) {
		COLOR = outline_color;
	}
	if (UV.y <= SCREEN_PIXEL_SIZE.y * 10.0 * float(stroke_width)) {
		COLOR = outline_color;
	}
}