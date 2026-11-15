extends Node2D

@export var fire_spread: FireSpread
@export var tile_layer: TileMapLayer
@export var burning_scene: PackedScene  

var _flames: Dictionary = {}   

func _ready() -> void:
	fire_spread.tile_ignited.connect(_on_ignited)
	fire_spread.tile_burned_out.connect(_on_burned_out)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed \
			and event.button_index == MOUSE_BUTTON_LEFT:
		var local_pos := tile_layer.to_local(get_global_mouse_position())
		fire_spread.ignite(tile_layer.local_to_map(local_pos))

func _on_ignited(cell: Vector2i) -> void:
	var flame := burning_scene.instantiate() as Node2D
	add_child(flame)
	flame.global_position = tile_layer.to_global(tile_layer.map_to_local(cell))
	_flames[cell] = flame

func _on_burned_out(cell: Vector2i) -> void:
	if _flames.has(cell):
		_flames[cell].queue_free()
		_flames.erase(cell)
