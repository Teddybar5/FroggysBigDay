class_name NPC extends CharacterBody2D

#for movement
@export var speed: float = 40.0
@export var pace_distance: float = 40.0
var direction: int = 1
var start_x: float

var player_in_range = false
var has_talked = false

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var player_character: Player = $"../PlayerCharacter"

@onready var dialogue_box: RichTextLabel = $"../CanvasLayer/DialogueScrollBox/Panel/VBoxContainer/dialogue"
@onready var dialogue_scroll_box: Control = $"../CanvasLayer/DialogueScrollBox"
@onready var player_choice: RichTextLabel = $"../CanvasLayer/DialogueScrollBox/Panel/VBoxContainer/playerChoice"
@onready var dialogue_manager: DialogueManager = $"../DialogueManager"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_x = global_position.x
	animation_player.play("idle")
	dialogue_scroll_box.hide()
	add_collision_exception_with(player_character)
	player_character.add_collision_exception_with(self)
	
func _physics_process(_delta: float) -> void:
	if player_in_range:
		velocity.x = 0
	else:
		# turn around at either end of the path, or when hitting a wall
		if global_position.x >= start_x + pace_distance:
			direction = -1
		elif global_position.x <= start_x - pace_distance:
			direction = 1
		elif is_on_wall():
			direction *= -1
		velocity.x = direction * speed
	move_and_slide()
	
	#add animation later
	if velocity.x == 0:
		pass
		#animation_player.play("idle")
	else:
		#animation_player.play("walk")
		$Sprite2D.flip_h = direction > 0
	
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
	player_character.can_move = false
	await dialogue_manager.runTortieDialogue(has_talked, false)
	has_talked = true
	player_character.can_move = true
	
func check_flowers() -> void:
	dialogue_scroll_box.show()
	if "Flowers" in player_character.inventory:
		await dialogue_manager.runTortieDialogue(has_talked, true)
		#START COOL CUTSCENE
		await get_tree().create_timer(1.0).timeout
		get_tree().change_scene_to_file("res://scenes/levels/TortieCutscene.tscn")	
	else:
		await dialogue_manager.runTortieDialogue(has_talked, false)
