extends CanvasLayer

# Higher zoom = shows LESS of the world. Tweak in the Inspector.
@export var map_zoom: float = 1.0
# Only draw things on these visibility layers in the minimap.
# 1 = layer 1 only. Put ground/walls on layer 1, everything else on other layers.
@export_flags_2d_render var minimap_layers: int = 1
# Rotate the frog icon to match the player's rotation
@export var rotate_icon: bool = false

@onready var container: SubViewportContainer = $Frame/Overlay/SubViewportContainer
@onready var sub_viewport: SubViewport = $Frame/Overlay/SubViewportContainer/SubViewport
@onready var camera: Camera2D = $Frame/Overlay/SubViewportContainer/SubViewport/Camera2D
@onready var frog_icon: TextureRect = $Frame/Overlay/FrogIcon

var player: Node2D

func _ready() -> void:
	# Render the same world as the main game
	sub_viewport.world_2d = get_viewport().world_2d
	# Limit what the minimap draws
	sub_viewport.canvas_cull_mask = minimap_layers
	# Chunky, low-res look
	container.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	camera.zoom = Vector2(map_zoom, map_zoom)

func _process(_delta: float) -> void:
	if player == null:
		player = get_tree().get_first_node_in_group("player") as Node2D
		return

	camera.global_position = player.global_position

	if rotate_icon:
		frog_icon.rotation = player.rotation
