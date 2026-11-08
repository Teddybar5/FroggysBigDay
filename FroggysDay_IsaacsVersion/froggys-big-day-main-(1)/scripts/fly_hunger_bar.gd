extends HBoxContainer

signal flies_depleted

@export var full_fly: Texture2D
@export var empty_fly: Texture2D
@export var max_flies: int = 5
#timer
@export var tick_interval: float = 5.0   # seconds per fly

var current_flies: int

func _ready() -> void:
	current_flies = max_flies
	buildFlies()
	updateFlies()
	startDraining()

func startDraining() -> void:
	while true:
		await get_tree().create_timer(tick_interval).timeout
		if current_flies > 0:
			setFlies(current_flies - 1)

func buildFlies() -> void:
	for child in get_children():
		child.queue_free()
	for i in max_flies:
		var fly := TextureRect.new()
		fly.texture = full_fly
		fly.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		fly.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		fly.custom_minimum_size = Vector2(48, 48)   # change this to resize
		add_child(fly)

func setFlies(value: int) -> void:
	current_flies = clampi(value, 0, max_flies)
	updateFlies()
	if current_flies == 0:
		flies_depleted.emit()

func updateFlies() -> void:
	var flies := get_children()
	for i in flies.size():
		flies[i].texture = full_fly if i < current_flies else empty_fly
