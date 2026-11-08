shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest_mipmap;
uniform float blur_amount : hint_range(2.5, 5.5) = 1.5;

void fragment() {
    COLOR = textureLod(screen_texture, SCREEN_UV, blur_amount);
}