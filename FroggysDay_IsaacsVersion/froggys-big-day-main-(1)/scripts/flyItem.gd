class_name fly extends Node


var player_in_range = false
@onready var player_character: Player = $"../PlayerCharacter"
@onready var dialogue_box: RichTextLabel = $"../CanvasLayer/DialogueScrollBox/Panel/VBoxContainer/dialogue"
@onready var dialogue_scroll_box: Control = $"../CanvasLayer/DialogueScrollBox"
@onready var skill_check_manager: SkillCheckManager = $"../SkillCheckManager"
@onready var dialogue_manager: DialogueManager = $"../DialogueManager"
@onready var fly_hunger_bar: HBoxContainer = $"../CanvasLayer/FlyHungerBar"


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
		eatFly()


func eatFly() -> void:
	fly_hunger_bar.setFlies(fly_hunger_bar.current_flies + 1)
	queue_free()
