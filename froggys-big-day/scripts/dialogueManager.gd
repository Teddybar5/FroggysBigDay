class_name DialogueManager extends Node

@onready var dialogue: RichTextLabel = $"../CanvasLayer/DialogueScrollBox/Panel/VBoxContainer/dialogue"
@onready var dialogue_scroll_box: Control = $"../CanvasLayer/DialogueScrollBox"
@onready var player_choice: RichTextLabel = $"../CanvasLayer/DialogueScrollBox/Panel/VBoxContainer/playerChoice"
@onready var skill_check_manager: SkillCheckManager = $"../SkillCheckManager"
	
func runFlowerDialogue() -> bool:
	dialogue.append_text("You come across a group of flowers together in a field.\n")
	await get_tree().create_timer(1.5).timeout
	dialogue.append_text("While they have brilliant red blossoms on the tips of their stems, the bases are surrounded by razor sharp leaves.\n")
	await get_tree().create_timer(1.5).timeout
	#Options
	var options: Array[String] = ["Brave the thicket of thorns", "Use Sheers to trim the thorns", "Reason with the thorns"]
	player_choice.show_options(options)
	var choice: int = await player_choice.ask(options)
	
	match choice:
		0:
			#Check Courage
			if await skill_check_manager.CheckSkill(2, 2):
				dialogue.append_text("You steel your mind, understanding that a flower for a mother is worth far more than some cuts across your body.\n")
				await get_tree().create_timer(1.5).timeout
				dialogue.append_text("You push through the thorns until you grab a flower, and rip it out of the ground. FLOWERS RECEIVED!\n")
				return true
			else:
				dialogue.append_text("The thorns are just too scary, you try to move but your feet feel glued to the ground.\n")
				dialogue.on_option()
		1:
			#Check for sheers
			dialogue.append_text("Second Choice\n")
		2: 
			#Check Empathy
			if await skill_check_manager.CheckSkill(1, 2):
				dialogue.append_text("While at first the thorns seem unreasonable, you see that they are merely trying to protect their lovely blossoms.\n")
				await get_tree().create_timer(1.5).timeout
				dialogue.append_text("You explain that you just need a few for a lovely gift, and that you promise each blossom will be treated wonderfully.\n")
				await get_tree().create_timer(1.5).timeout
				dialogue.append_text("Hearing this, the thorns seem to split apart and allow you passage towards the flowers. FLOWERS RECEIVED!\n")
				return true
			else:
				dialogue.append_text("The thorns seem unfathomably prickly and unreasonable, they stare at you, almost as if they are laughing.\n")
				dialogue.on_option()
	return false
	
	
	
