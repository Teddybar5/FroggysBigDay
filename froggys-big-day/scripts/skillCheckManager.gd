class_name SkillCheckManager extends Node

var stats: Array[int] = [0, 0, 0, 0]

@onready var player_character: Player = $"../PlayerCharacter"
@onready var dialogue_box: RichTextLabel = $"../CanvasLayer/DialogueScrollBox/Panel/VBoxContainer/dialogue"
@onready var dialogue_scroll_box: Control = $"../CanvasLayer/DialogueScrollBox"

func CheckSkill(skill : int, min : int) -> bool:
	player_character.update_stats()
	stats = player_character.stats
	if stats[skill] >= min:
		dialogue_box.append_text("Success!\n")
		dialogue_box.on_option()
		return true	
	dialogue_box.append_text("You failed the check!\n")
	dialogue_box.on_option()
	return false
