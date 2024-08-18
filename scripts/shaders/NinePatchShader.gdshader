shader_type canvas_item;

uniform vec2 mesh_size;
global uniform vec2 target_res;

uniform int right;
uniform int top;
uniform int left;
uniform int bottom;

uniform vec4 color: source_color;
uniform bool enabled;
uniform float pulse_speed;
uniform float overlay_max_alpha;

float map(float value, float originalMin, float originalMax, float newMin, float newMax) {
    return (value - originalMin) / (originalMax - originalMin) * (newMax - newMin) + newMin;
} 

float process_axis(float coord, float pixel, float texture_pixel, float start, float end) {
	if (coord > 1.0 - end * pixel) {
		return map(coord, 1.0 - end * pixel, 1.0, 1.0 - texture_pixel * end, 1.0);
	} else if (coord > start * pixel) {
		return map(coord, start * pixel, 1.0 - end * pixel, start * texture_pixel, 1.0 - end * texture_pixel);
	} else {
		return map(coord, 0.0, start * pixel, 0.0, start * texture_pixel);
	}
}

void fragment() {
	vec2 target_mesh_size = mesh_size / 32.0;
	vec2 pixel_size = TEXTURE_PIXEL_SIZE / target_mesh_size;
	
	vec2 mappedUV = vec2(
		process_axis(UV.x, pixel_size.x, TEXTURE_PIXEL_SIZE.x, float(left), float(right)),
		process_axis(UV.y, pixel_size.y, TEXTURE_PIXEL_SIZE.y, float(top), float(bottom))
	);
	
	float percent_overlay = 0.0;
	if (enabled)
		percent_overlay = 0.5 * overlay_max_alpha * sin((1.0 / pulse_speed) * PI * TIME) + (overlay_max_alpha / 2.0);

	COLOR = mix(texture(TEXTURE, mappedUV), color, percent_overlay);
}