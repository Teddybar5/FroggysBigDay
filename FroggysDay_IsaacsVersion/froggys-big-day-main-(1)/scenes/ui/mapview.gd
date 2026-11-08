extends Control

@export var world_units_per_pixel: float = 3.0
@export var player_icon: Texture2D
@export var player_icon_size: float = 32.0
@export var marker_size: float = 5.0
@export var rotate_icon: bool = false

@export_group("Background")
@export var noise_seed: int = 1
@export var splotch_size: float = 0.015   # lower = bigger, softer patches
@export var tile_pixels: int = 128
@export_range(0.0, 1.0, 0.01) var contrast: float = 0.35   # 0 = flat color, 1 = full contrast
@export var color_dark := Color(0.374, 0.698, 0.437, 1.0)
@export var color_mid := Color(0.458, 0.768, 0.223, 1.0)
@export var color_light := Color(0.485, 0.821, 0.397, 1.0)

@export_group("Border")
@export var ring_color := Color(0.0, 0.0, 0.0, 1.0)
@export var ring_width: float = 3.0

var marker_groups := {
	"minimap_quest": Color.YELLOW,
	"minimap_item": Color.BLUE_VIOLET,
	"minimap_npc": Color.CYAN,
}

var player: Node2D
var bg_texture: ImageTexture

func _ready() -> void:
	clip_contents = true
	bg_texture = _make_background()
	resized.connect(_update_mask)
	_update_mask()

func _update_mask() -> void:
	if material is ShaderMaterial:
		(material as ShaderMaterial).set_shader_parameter("map_size", size)

func _make_background() -> ImageTexture:
	var noise := FastNoiseLite.new()
	noise.seed = noise_seed
	noise.noise_type = FastNoiseLite.TYPE_SIMPLEX_SMOOTH
	noise.frequency = splotch_size
	noise.fractal_octaves = 1   # fewer octaves = smoother, less fine detail

	var gradient := Gradient.new()
	gradient.set_color(0, color_dark)
	gradient.set_color(1, color_light)
	gradient.add_point(0.5, color_mid)

	var gray := noise.get_seamless_image(tile_pixels, tile_pixels)
	var colored := Image.create(tile_pixels, tile_pixels, false, Image.FORMAT_RGB8)
	for x in tile_pixels:
		for y in tile_pixels:
			var v := gray.get_pixel(x, y).r
			v = lerpf(0.5, v, contrast)   # pull values toward the middle
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

	# 2. Markers (pinned to the circle's edge when out of range)
	var max_radius: float = minf(size.x, size.y) / 2.0 - marker_size - ring_width
	for group_name in marker_groups:
		var color: Color = marker_groups[group_name]
		for node in get_tree().get_nodes_in_group(group_name):
			if not node is Node2D:
				continue
			var offset: Vector2 = (node.global_position - player.global_position) / world_units_per_pixel
			if offset.length() > max_radius:
				offset = offset.normalized() * max_radius
			draw_circle(center + offset, marker_size, color)

	# 3. Border ring
	var radius: float = minf(size.x, size.y) / 2.0
	draw_arc(center, radius - ring_width / 2.0, 0.0, TAU, 64, ring_color, ring_width, true)

	# 4. Player icon, always on top
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
