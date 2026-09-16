class_name Flower extends Node

var player_in_range = false
@onready var player_character: Player = $"../PlayerCharacter"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	player_in_range = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	player_in_range = false

func _input(event: InputEvent) -> void:
	if player_in_range and event.is_action_pressed("interact"):
		pick_up_object()
		
func pick_up_object() -> void:
	player_character.UpdateFlowers(1)
	queue_free()
