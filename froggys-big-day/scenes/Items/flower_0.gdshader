shader_type canvas_item;

uniform float strength = 0.03;   // how far the tops sway (in UV units, 0.03 = 3% of the image width)
uniform float speed = 1.5;       // sway speed
uniform float spread = 6.0;      // how much the sway differs across the image (0 = all move together)
uniform float gust : hint_range(0.0, 1.0) = 0.4; // adds a slower, irregular secondary wobble

void fragment() {
	// 0 at the bottom (the stems stay planted), 1 at the top
	float h = 1.0 - UV.y;
	h *= h; // bends more toward the tips

	float t = TIME * speed;
	float wave = sin(t + UV.x * spread);
	wave += sin(t * 0.37 + UV.x * spread * 0.5) * gust;

	vec2 uv = UV + vec2(wave * strength * h, 0.0);
	COLOR = texture(TEXTURE, uv);
}