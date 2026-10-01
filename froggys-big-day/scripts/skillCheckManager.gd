class_name SkillCheckManager extends Node

var stats: Array[int] = [0, 0, 0, 0]
var statNames: Array[String] = ["Wisdon", "Empathy", "Courage", "Strength"]

@onready var player_character: Player = $"../PlayerCharacter"
@onready var dialogue_box: RichTextLabel = $"../CanvasLayer/DialogueScrollBox/Panel/VBoxContainer/dialogue"
@onready var dialogue_scroll_box: Control = $"../CanvasLayer/DialogueScrollBox"

func CheckSkill(skill : int, min : int) -> bool:
	dialogue_box.append_text(statNames[skill] + " check...\n")
	dialogue_box.on_option()
	await get_tree().create_timer(0.5).timeout
	
	player_character.update_stats()
	stats = player_character.stats
	if stats[skill] >= min:
		dialogue_box.append_text("Success!\n")
		dialogue_box.on_option()
		return true	
	dialogue_box.append_text("You failed the check!\n")
	dialogue_box.on_option()
	return false
