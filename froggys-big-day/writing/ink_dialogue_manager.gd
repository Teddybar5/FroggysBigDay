class_name InkDialogueManager extends Node
## Ink tags understood:
##   # pause: 1.5        wait after the line
##   # check: 2 2        skill check, result goes into "check_passed"
##   # quest: some_id    calls QuestManager.accept_quest("some_id")
##   # give: Item        adds "Item" to the player's inventory

@export_file("*.json") var story_path: String = ""

@onready var dialogue: RichTextLabel = $"../CanvasLayer/DialogueScrollBox/Panel/VBoxContainer/dialogue"
@onready var player_choice: RichTextLabel = $"../CanvasLayer/DialogueScrollBox/Panel/VBoxContainer/playerChoice"
@onready var skill_check_manager: SkillCheckManager = $"../SkillCheckManager"
@onready var player_character: Player = $"../PlayerCharacter"

@onready var ink_player = $InkPlayer

const DEFAULT_PAUSE := 1.0

var _story_loaded := false
var _story_failed := false


func _ready() -> void:
	if story_path.is_empty():
		push_error("InkDialogueManager: story_path is empty. Set it in the Inspector.")
		_story_failed = true
		return

	var story_resource := InkResource.new()
	story_resource.json = FileAccess.get_file_as_string(story_path)
	ink_player.ink_file = story_resource
	ink_player.loads_in_background = false
	ink_player.loaded.connect(_on_story_loaded)

	await get_tree().process_frame
	ink_player.create_story()


func _on_story_loaded(successfully: bool) -> void:
	_story_loaded = successfully
	_story_failed = not successfully
	if _story_failed:
		push_error("InkDialogueManager: the ink story failed to load.")


func start_dialogue(knot: String, variables: Dictionary = {}) -> bool:
	while not _story_loaded:
		if _story_failed:
			return false
		await get_tree().process_frame

	_set_default_variables()
	for key in variables:
		ink_player.set_variable(key, variables[key])

	dialogue.clear_dialogue()
	ink_player.choose_path(knot)

	var first_line := true

	while true:
		if ink_player.can_continue:
			var text: String = ink_player.continue_story()
			if text.strip_edges() != "":
				if first_line:
					text = "\n" + text
					first_line = false
				dialogue.append_text(text)
				dialogue.on_option()
			await _handle_tags(ink_player.current_tags)
		elif ink_player.current_choices.size() > 0:
			var index: int = await player_choice.ask(_get_choice_texts())
			ink_player.choose_choice_index(index)
		else:
			break

	dialogue.append_text("\n")
	return ink_player.get_variable("success") == true


func _set_default_variables() -> void:
	ink_player.set_variable("check_passed", false)
	ink_player.set_variable("success", false)


func _get_choice_texts() -> Array[String]:
	var options: Array[String] = []
	for choice in ink_player.current_choices:
		options.append(choice if choice is String else choice.text)
	return options


func _handle_tags(tags: Array) -> void:
	var pause := DEFAULT_PAUSE

	for tag: String in tags:
		tag = tag.strip_edges()
		if tag.begins_with("pause:"):
			pause = float(tag.trim_prefix("pause:").strip_edges())
		elif tag.begins_with("check:"):
			var args := tag.trim_prefix("check:").strip_edges().split(" ", false)
			var passed: bool = await skill_check_manager.CheckSkill(int(args[0]), int(args[1]))
			ink_player.set_variable("check_passed", passed)
		elif tag.begins_with("quest:"):
			QuestManager.accept_quest(tag.trim_prefix("quest:").strip_edges())
		elif tag.begins_with("give:"):
			player_character.inventory.append(tag.trim_prefix("give:").strip_edges())

	await get_tree().create_timer(pause).timeout
