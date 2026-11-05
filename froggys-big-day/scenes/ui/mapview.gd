extends Control

@export var world_units_per_pixel: float = 4.0
@export var player_icon: Texture2D
@export var player_icon_size: float = 20.0
@export var marker_size: float = 5.0
@export var rotate_icon: bool = false

@export_group("Background")
@export var noise_seed: int = 1
@export var splotch_size: float = 0.03   # lower = bigger splotches, higher = smaller
@export var tile_pixels: int = 128       # size of one repeating tile on the minimap
@export var color_dark := Color(0.10, 0.22, 0.10)
@export var color_mid := Color(0.18, 0.34, 0.16)
@export var color_light := Color(0.28, 0.45, 0.22)

var marker_groups := {
	"minimap_item": Color.RED,
	"minimap_npc": Color.CYAN,
}

var player: Node2D
var bg_texture: ImageTexture

func _ready() -> void:
	clip_contents = true
	bg_texture = _make_background()

func _make_background() -> ImageTexture:
	var noise := FastNoiseLite.new()
	noise.seed = noise_seed
	noise.noise_type = FastNoiseLite.TYPE_SIMPLEX_SMOOTH
	noise.frequency = splotch_size
	noise.fractal_octaves = 3

	var gradient := Gradient.new()
	gradient.set_color(0, color_dark)
	gradient.set_color(1, color_light)
	gradient.add_point(0.5, color_mid)

	# Seamless so the tiles join without visible edges
	var gray := noise.get_seamless_image(tile_pixels, tile_pixels)
	var colored := Image.create(tile_pixels, tile_pixels, false, Image.FORMAT_RGB8)
	for x in tile_pixels:
		for y in tile_pixels:
			var v := gray.get_pixel(x, y).r
			colored.set_pixel(x, y, gradient.sample(v))

	return ImageTexture.create_from_image(colored)

func _process(_delta: float) -> void:
	if player == null:
		player = get_tree().get_first_node_in_group("player") as Node2D
	queue_redraw()

func _draw() -> void:
	if player == null:
		return

	var center := size / 2.0

	# 1. Scrolling splotchy background
	var tile := float(tile_pixels)
	var scroll := player.global_position / world_units_per_pixel
	var start := Vector2(
		fposmod(center.x - scroll.x, tile),
		fposmod(center.y - scroll.y, tile)
	) - Vector2(tile, tile)
	draw_texture_rect(bg_texture, Rect2(start, size + Vector2(tile, tile) * 2.0), true)

	# 2. Markers
	for group_name in marker_groups:
		var color: Color = marker_groups[group_name]
		for node in get_tree().get_nodes_in_group(group_name):
			if not node is Node2D:
				continue
			var offset: Vector2 = (node.global_position - player.global_position) / world_units_per_pixel
			var pos := center + offset
			pos = pos.clamp(Vector2(marker_size, marker_size), size - Vector2(marker_size, marker_size))
			draw_circle(pos, marker_size, color)

	# 3. Player icon, always on top
	if player_icon:
		var half := Vector2(player_icon_size, player_icon_size) / 2.0
		if rotate_icon:
			draw_set_transform(center, player.rotation)
			draw_texture_rect(player_icon, Rect2(-half, half * 2.0), false)
			draw_set_transform(Vector2.ZERO)
		else:
			draw_texture_rect(player_icon, Rect2(center - half, half * 2.0), false)
	else:
		draw_circle(center, marker_size * 1.5, Color.GREEN)
