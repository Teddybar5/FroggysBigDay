class_name NPC extends CharacterBody2D

var player_in_range = false
var has_talked = false

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var dialogue_box: RichTextLabel = $"../DialogueBox"
@onready var player_character: Player = $"../PlayerCharacter"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation_player.play("idle")
	dialogue_box.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _on_interaction_area_body_entered(body: Node2D) -> void:
	player_in_range = true

func _on_interaction_area_body_exited(body: Node2D) -> void:
	player_in_range = false
	
func _input(event: InputEvent) -> void:
	if player_in_range and event.is_action_pressed("interact") and !has_talked:
		run_dialogue()
	elif  player_in_range and event.is_action_pressed("interact") and has_talked:
		check_flowers()
	
func run_dialogue() -> void:
	dialogue_box.show()
	has_talked = true
	
func check_flowers() -> void:
	if player_character.flowers >= 5:
		dialogue_box.text = "Yay, Thank you! You win!"
	else:
		dialogue_box.text = "Not enough!"
