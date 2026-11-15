class_name FireSpread
extends Node

signal tile_ignited(cell: Vector2i)
signal tile_burned_out(cell: Vector2i)

@export var tile_layer: TileMapLayer
@export var spread_chance: float = 0.3   
@export var tick_time: float = 0.5       
@export var burnt_source_id: int = 0
@export var burnt_atlas_coords: Vector2i = Vector2i(4, 0)

const NEIGHBORS := [Vector2i.UP, Vector2i.DOWN, Vector2i.LEFT, Vector2i.RIGHT]

var burning: Dictionary = {}   
var _timer: Timer

func _ready() -> void:
	_timer = Timer.new()
	_timer.wait_time = tick_time
	_timer.autostart = true
	_timer.timeout.connect(_on_tick)
	add_child(_timer)

func _is_flammable(cell: Vector2i) -> bool:
	var data := tile_layer.get_cell_tile_data(cell)
	return data != null and data.get_custom_data("flammable")

func ignite(cell: Vector2i) -> bool:
	if burning.has(cell) or not _is_flammable(cell):
		return false
	var data := tile_layer.get_cell_tile_data(cell)
	var duration: float = data.get_custom_data("burn_time")
	burning[cell] = maxi(1, ceili(duration / tick_time))
	tile_ignited.emit(cell)
	return true

func _on_tick() -> void:
	var to_ignite: Array[Vector2i] = []
	var to_burn_out: Array[Vector2i] = []

	for cell: Vector2i in burning:
		burning[cell] -= 1
		if burning[cell] <= 0:
			to_burn_out.append(cell)
		for dir in NEIGHBORS:
			var n: Vector2i = cell + dir
			if not burning.has(n) and _is_flammable(n) and randf() < spread_chance:
				to_ignite.append(n)

	for cell in to_burn_out:
		burning.erase(cell)
		tile_layer.set_cell(cell, burnt_source_id, burnt_atlas_coords)
		tile_burned_out.emit(cell)
	for cell in to_ignite:
		ignite(cell)  
