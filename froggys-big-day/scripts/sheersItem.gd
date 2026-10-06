class_name Sheers extends Node


var player_in_range = false
@onready var player_character: Player = $"../PlayerCharacter"
@onready var dialogue_box: RichTextLabel = $"../CanvasLayer/DialogueScrollBox/Panel/VBoxContainer/dialogue"
@onready var dialogue_scroll_box: Control = $"../CanvasLayer/DialogueScrollBox"
@onready var skill_check_manager: SkillCheckManager = $"../SkillCheckManager"
@onready var dialogue_manager: DialogueManager = $"../DialogueManager"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "PlayerCharacter":
		player_in_range = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == "PlayerCharacter":
		player_in_range = false
		dialogue_scroll_box.hide()

func _input(event: InputEvent) -> void:
	if player_in_range and event.is_action_pressed("interact"):
		run_dialogue()
		
func run_dialogue() -> void:
	dialogue_scroll_box.show()

	#skill check
	if await dialogue_manager.runShearsDialogue(): 
		await get_tree().create_timer(1.0).timeout
		pick_up_object()
	else: 
		await get_tree().create_timer(2.0).timeout
		queue_free()
		#fun particle effect here


func pick_up_object() -> void:
	player_character.inventory.append("Shears")
	queue_free()
