shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, filter_linear_mipmap;

// Fraction of the viewport this rect covers (set by script below, or by hand)
uniform vec2 rect_screen_fraction = vec2(1.0, 1.0);

uniform float curvature : hint_range(0.0, 0.5) = 0.02;
uniform float scanline_count = 180.0;
uniform float scanline_intensity : hint_range(0.0, 1.0) = 0.25;
uniform float aberration : hint_range(0.0, 0.01) = 0.002;
uniform float vignette : hint_range(0.0, 1.0) = 0.35;
uniform float noise_amount : hint_range(0.0, 0.3) = 0.04;
uniform float flicker : hint_range(0.0, 0.1) = 0.015;
uniform float brightness = 1.1;

float hash(vec2 p) {
	return fract(sin(dot(p, vec2(12.9898, 78.233))) * 43758.5453);
}

void fragment() {
	vec2 p = UV * 2.0 - 1.0;

	// Barrel distortion (curved glass)
	vec2 c = p * (1.0 + dot(p, p) * curvature);
	vec2 suv = c * 0.5 + 0.5;

	// Convert the local offset into screen space and sample the game
	vec2 off = (suv - UV) * rect_screen_fraction;
	vec2 s = SCREEN_UV + off;
	vec3 col;
	col.r = texture(screen_texture, s + vec2(aberration, 0.0)).r;
	col.g = texture(screen_texture, s).g;
	col.b = texture(screen_texture, s - vec2(aberration, 0.0)).b;

	// Scanlines
	float scan = sin(suv.y * scanline_count * 6.28318) * 0.5 + 0.5;
	col *= 1.0 - scanline_intensity * scan;

	// Noise and flicker
	col += (hash(suv * 500.0 + fract(TIME)) - 0.5) * noise_amount;
	col *= 1.0 + sin(TIME * 60.0) * flicker;

	// Vignette and brightness
	col *= 1.0 - dot(p, p) * vignette;
	col *= brightness;

	// Black outside the curved screen edge
	float inside = step(0.0, suv.x) * step(suv.x, 1.0) * step(0.0, suv.y) * step(suv.y, 1.0);

	COLOR = vec4(col * inside, 1.0);
}