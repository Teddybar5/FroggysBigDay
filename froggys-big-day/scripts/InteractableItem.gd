class_name InteractableItem extends Sprite2D

@export_group("Dialogue")
@export var dialogue_knot: String = ""        # which ink section to run, e.g. "sheers"
@export var required_item: String = ""        # optional, sets ink var "has_<item>"
@export var end_delay: float = 2.0            # pause after dialogue

@export_group("Appearance")
@export var item_texture: Texture2D           # the sprite shown for this item
@export var tint: Color = Color.WHITE

@export_group("Outcome")
@export var item_name: String = ""            # item the ink gives, e.g. "Shears" (must match the # give: tag)
@export var destroy_on_success: bool = true
@export var destroy_on_fail: bool = false
@export var fail_effect: PackedScene          # optional particle effect on failure

@onready var area: Area2D = $Area2D

var player_character: Player
var dialogue_scroll_box: Control
var ink_dialogue_manager: InkDialogueManager

var player_in_range := false
var is_talking := false


func _ready() -> void:
	if item_texture:
		texture = item_texture
	modulate = tint

	player_character = get_tree().get_first_node_in_group("player") as Player
	dialogue_scroll_box = get_tree().get_first_node_in_group("dialogue_box") as Control
	ink_dialogue_manager = get_tree().get_first_node_in_group("ink_manager") as InkDialogueManager

	assert(player_character, "Item: no node in group 'player'")
	assert(dialogue_scroll_box, "Item: no node in group 'dialogue_box'")
	assert(ink_dialogue_manager, "Item: no node in group 'ink_manager'")

	area.body_entered.connect(_on_body_entered)
	area.body_exited.connect(_on_body_exited)


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		player_in_range = true


func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		player_in_range = false
		if not is_talking:
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

	var count_before := _count_item()

	await ink_dialogue_manager.start_dialogue(dialogue_knot, _build_ink_variables())

	# Success = the ink's "# give:" tag added the item during the conversation
	var success := _count_item() > count_before

	if end_delay > 0.0:
		await get_tree().create_timer(end_delay).timeout

	player_character.can_move = true
	dialogue_scroll_box.hide()
	is_talking = false

	if success:
		_on_success()
	else:
		_on_fail()


func _count_item() -> int:
	if item_name.is_empty():
		return 0
	return player_character.inventory.count(item_name)


func _on_success() -> void:
	if destroy_on_success:
		queue_free()


func _on_fail() -> void:
	if fail_effect:
		var fx := fail_effect.instantiate() as Node2D
		get_parent().add_child(fx)
		fx.global_position = global_position
	if destroy_on_fail:
		queue_free()


# Override in a child script if an item needs custom ink variables
func _build_ink_variables() -> Dictionary:
	var vars := {}
	if not required_item.is_empty():
		vars["has_" + required_item.to_lower()] = required_item in player_character.inventory
	return vars
