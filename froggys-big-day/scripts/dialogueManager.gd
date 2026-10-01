class_name DialogueManager extends Node

@onready var dialogue: RichTextLabel = $"../CanvasLayer/DialogueScrollBox/Panel/VBoxContainer/dialogue"
@onready var dialogue_scroll_box: Control = $"../CanvasLayer/DialogueScrollBox"
@onready var player_choice: RichTextLabel = $"../CanvasLayer/DialogueScrollBox/Panel/VBoxContainer/playerChoice"
	
func runFlowerDialogue() -> void:
	dialogue.append_text("You come across a group of flowers together in a field.\n")
	await get_tree().create_timer(1.5).timeout
	dialogue.append_text("While they have brilliant red blossoms on the tips of their stems, the bases are surrounded by razor sharp leaves.\n")
	await get_tree().create_timer(1.5).timeout
	var options: Array[String] = ["Brave the thicket of thorns", "Use Sheers to trim the thorns", "Reason with the thorns"]
	player_choice.show_options(options)
