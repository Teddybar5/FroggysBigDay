class_name NPC extends CharacterBody2D

var player_in_range = false
var has_talked = false

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var player_character: Player = $"../PlayerCharacter"

@onready var dialogue_box: RichTextLabel = $"../CanvasLayer/DialogueScrollBox/Panel/VBoxContainer/dialogue"
@onready var dialogue_scroll_box: Control = $"../CanvasLayer/DialogueScrollBox"
@onready var player_choice: RichTextLabel = $"../CanvasLayer/DialogueScrollBox/Panel/VBoxContainer/playerChoice"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation_player.play("idle")
	dialogue_scroll_box.hide()
	player_choice.option_selected.connect(_on_player_choice_selected)
	
func _on_interaction_area_body_entered(body: Node2D) -> void:
	if body.name == "PlayerCharacter":
		player_in_range = true
	
func _on_interaction_area_body_exited(body: Node2D) -> void:
	if body.name == "PlayerCharacter":
		player_in_range = false
		dialogue_scroll_box.hide()
	
func _input(event: InputEvent) -> void:
	if player_in_range and event.is_action_pressed("interact") and !has_talked:
		run_dialogue()
	elif  player_in_range and event.is_action_pressed("interact") and has_talked:
		check_flowers()
	
func run_dialogue() -> void:
	dialogue_scroll_box.show()
	dialogue_box.append_text("I need help finding flowers for my mom!\n")
	var options: Array[String] = ["Okay, I can help you", "Figure it our yourself!"]
	player_choice.show_options(options)
	
	dialogue_box.on_option()
	has_talked = true
	
func check_flowers() -> void:
	dialogue_scroll_box.show()
	if player_character.flowers >= 5:
		dialogue_box.append_text("Yay you win!\n")
		dialogue_box.on_option()
	else:
		dialogue_box.append_text("Not enough...\n")
		dialogue_box.on_option()

func _on_player_choice_selected(index: int) -> void:
	match index:
		0:
			dialogue_box.append_text("Great, let's find some flowers!\n")
		1:
			dialogue_box.append_text("Fine, be that way.\n")
	dialogue_box.on_option()
