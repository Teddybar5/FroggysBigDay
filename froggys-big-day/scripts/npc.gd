class_name NPC extends CharacterBody2D

@export_group("Movement")
@export var speed: float = 40.0
@export var pace_distance: float = 40.0
@export var can_pace: bool = true

@export_group("Dialogue")
@export var dialogue_knot: String = ""          # e.g. "piggy"
@export var quest_id: String = ""               # e.g. "piggieQuest" (leave empty for no quest)
@export var quest_delay: float = 2.0
@export var required_item: String = ""          # e.g. "Gems" -> sets ink var "has_gems"

@export_group("Animations")
@export var anim_idle: StringName = &"idle"
@export var anim_walk_left: StringName = &"walk_left"
@export var anim_walk_right: StringName = &"walk_right"

@export_group("Appearance")
@export var tint: Color = Color.WHITE
@export var randomize_tint: bool = false
@export_range(0.0, 0.3) var random_tint_amount: float = 0.1

var direction: int = 1
var start_x: float
var player_in_range := false
var is_talking := false

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

# Shared things, found at runtime instead of via hardcoded paths
var player_character: Player
var dialogue_scroll_box: Control
var ink_dialogue_manager: InkDialogueManager


func _ready() -> void:
	start_x = global_position.x
	animated_sprite.play(anim_idle)
	_apply_tint()

	# Look these up by group so the NPC works in any scene layout
	player_character = get_tree().get_first_node_in_group("player") as Player
	dialogue_scroll_box = get_tree().get_first_node_in_group("dialogue_box") as Control
	ink_dialogue_manager = get_tree().get_first_node_in_group("ink_manager") as InkDialogueManager

	dialogue_scroll_box.hide()
	add_collision_exception_with(player_character)
	player_character.add_collision_exception_with(self)


func _physics_process(_delta: float) -> void:
	if player_in_range or is_talking or not can_pace:
		velocity.x = 0
	else:
		if global_position.x >= start_x + pace_distance:
			direction = -1
			animated_sprite.play(anim_walk_right)
		elif global_position.x <= start_x - pace_distance:
			direction = 1
			animated_sprite.play(anim_walk_left)
		elif is_on_wall():
			direction *= -1
		velocity.x = direction * speed
	move_and_slide()


func _on_interaction_area_body_entered(body: Node2D) -> void:
	if body is Player:
		player_in_range = true


func _on_interaction_area_body_exited(body: Node2D) -> void:
	if body is Player:
		player_in_range = false
		dialogue_scroll_box.hide()


func _input(event: InputEvent) -> void:
	if player_in_range and not is_talking and event.is_action_pressed("interact"):
		run_dialogue()


func run_dialogue() -> void:
	if dialogue_knot.is_empty():
		return

	is_talking = true
	dialogue_scroll_box.show()
	player_character.can_move = false

	await ink_dialogue_manager.start_dialogue(dialogue_knot, _build_ink_variables())

	if not quest_id.is_empty():
		await get_tree().create_timer(quest_delay).timeout
		QuestManager.accept_quest(quest_id)

	player_character.can_move = true
	dialogue_scroll_box.hide()
	is_talking = false


# Override this in child scripts for NPC-specific ink variables
func _build_ink_variables() -> Dictionary:
	var vars := {}
	if not required_item.is_empty():
		vars["has_" + required_item.to_lower()] = required_item in player_character.inventory
	return vars
	
	
func _apply_tint() -> void:
	var final_color := tint
	if randomize_tint:
		# nudge each channel down by a small random amount
		final_color = Color(
			tint.r - randf_range(0.0, random_tint_amount),
			tint.g - randf_range(0.0, random_tint_amount),
			tint.b - randf_range(0.0, random_tint_amount),
			tint.a
		)
	animated_sprite.modulate = final_color
