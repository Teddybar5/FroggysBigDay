shader_type canvas_item;

uniform vec2 map_size = vec2(120.0);
varying vec2 local_pos;

void vertex() {
	local_pos = VERTEX;
}

void fragment() {
	float radius = min(map_size.x, map_size.y) * 0.5;
	float dist = distance(local_pos, map_size * 0.5);
	// Soft 1px edge so the circle isn't jagged
	COLOR.a *= 1.0 - smoothstep(radius - 1.0, radius, dist);
}