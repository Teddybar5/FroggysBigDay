class_name InkDialogueManager extends Node
## Runs conversations from an ink story using inkgd's InkPlayer.
##
## Usage from any script:
##   var got_it: bool = await ink_dialogue_manager.start_dialogue("flowers")
##   await ink_dialogue_manager.start_dialogue("tortie", {"has_talked": true})
##
## Ink tags understood (put them at the end of a line in your .ink file):
##   # pause: 1.5        wait this many seconds after the line is shown
##   # check: 2 2        run skill_check_manager.CheckSkill(2, 2); result goes
##                       into the ink variable "check_passed"
##   # quest: some_id    calls QuestManager.accept_quest("some_id")

# --- Your existing nodes (same paths as before) ---
@onready var dialogue: RichTextLabel = $"../CanvasLayer/DialogueScrollBox/Panel/VBoxContainer/dialogue"
@onready var player_choice: RichTextLabel = $"../CanvasLayer/DialogueScrollBox/Panel/VBoxContainer/playerChoice"
@onready var skill_check_manager: SkillCheckManager = $"../SkillCheckManager"
@onready var player_character: Player = $"../PlayerCharacter"

# --- Child node: add an InkPlayer under this node and assign your story JSON ---
@onready var ink_player = $InkPlayer

const DEFAULT_PAUSE := 1.0

var _story_loaded := false
var _story_failed := false


func _ready() -> void:
	# Build the story resource from the compiled JSON ourselves,
	# since the importer wasn't producing the right resource type.
	var story_resource := InkResource.new()
	story_resource.json = FileAccess.get_file_as_string("res://writing/froggy_quests.ink.json")
	ink_player.ink_file = story_resource
	ink_player.loads_in_background = false
	ink_player.loaded.connect(_on_story_loaded)

	# Let the scene finish setting up before inkgd adds its runtime node.
	await get_tree().process_frame
	ink_player.create_story()


func _on_story_loaded(successfully: bool) -> void:
	_story_loaded = successfully
	_story_failed = not successfully
	if _story_failed:
		push_error("InkDialogueManager: the ink story failed to load.")


## Starts the conversation at the given knot and waits until it finishes.
## `variables` are written into ink before it starts (e.g. {"has_talked": true}).
## Returns the value of the ink variable "success" when the conversation ends.
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


## Variables reset before every conversation.
## Both must be declared with VAR at the top of your ink file.
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

	await get_tree().create_timer(pause).timeout
