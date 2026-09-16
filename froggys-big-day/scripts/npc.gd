class_name NPC extends CharacterBody2D

var player_in_range = false
@onready var animation_player: AnimationPlayer = $AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation_player.play("idle")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _on_interaction_area_body_entered(body: Node2D) -> void:
	player_in_range = true

func _on_interaction_area_body_exited(body: Node2D) -> void:
	player_in_range = false
	
func _input(event: InputEvent) -> void:
	if player_in_range and event.is_action_pressed("interact"):
		run_dialogue()
	
func run_dialogue() -> void:
	print("Hello, traveler!")
