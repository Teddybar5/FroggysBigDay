class_name DialogueManager extends Node

@onready var dialogue: RichTextLabel = $"../CanvasLayer/DialogueScrollBox/Panel/VBoxContainer/dialogue"
@onready var dialogue_scroll_box: Control = $"../CanvasLayer/DialogueScrollBox"
@onready var player_choice: RichTextLabel = $"../CanvasLayer/DialogueScrollBox/Panel/VBoxContainer/playerChoice"
@onready var skill_check_manager: SkillCheckManager = $"../SkillCheckManager"
@onready var player_character: Player = $"../PlayerCharacter"

	
func runFlowerDialogue() -> bool:
	dialogue.clear_dialogue()
	dialogue.append_text("\nYou come across a group of flowers together in a field.\n")
	dialogue.on_option()
	await get_tree().create_timer(1.0).timeout
	dialogue.append_text("While they have brilliant red blossoms on the tips of their stems, the bases are surrounded by razor sharp leaves.\n")
	dialogue.on_option()
	await get_tree().create_timer(1.5).timeout
	#Options
	var options: Array[String] = ["Brave the thicket of thorns", "Use Shears to trim the thorns", "Reason with the thorns"]
	player_choice.show_options(options)
	var choice: int = await player_choice.ask(options)
	
	match choice:
		0:
			#Check Courage
			if await skill_check_manager.CheckSkill(2, 2):
				dialogue.append_text("You steel your mind, understanding that a flower for a mother is worth far more than some cuts across your body.\n")
				dialogue.on_option()
				await get_tree().create_timer(1.5).timeout
				dialogue.append_text("You push through the thorns until you grab a flower, and rip it out of the ground. FLOWERS RECEIVED!\n\n")
				dialogue.on_option()
				return true
			else:
				dialogue.append_text("The thorns are just too scary, you try to move but your feet feel glued to the ground.\n\n")
				dialogue.on_option()
				await get_tree().create_timer(1.5).timeout
		1:
			#Check for shears
			if "Shears" in player_character.inventory:
				dialogue.append_text("You trim through the thick thorns opening an easy path towards the flowers. FLOWERS RECEIVED!\n\n")
				dialogue.on_option()
				await get_tree().create_timer(1.5).timeout
				return true
			else:
				dialogue.append_text("You rummage through your bag for a pair of shears that you are certain you do not have.\n\n")
				dialogue.on_option()
				await get_tree().create_timer(1.5).timeout
		2: 
			#Check Empathy
			if await skill_check_manager.CheckSkill(1, 2):
				dialogue.append_text("While at first the thorns seem unreasonable, you see that they are merely trying to protect their lovely blossoms.\n")
				dialogue.on_option()
				await get_tree().create_timer(1.5).timeout
				dialogue.append_text("You explain that you just need a few for a lovely gift, and that you promise each blossom will be treated wonderfully.\n")
				dialogue.on_option()
				await get_tree().create_timer(1.5).timeout
				dialogue.append_text("Hearing this, the thorns seem to split apart and allow you passage towards the flowers. FLOWERS RECEIVED!\n\n")
				dialogue.on_option()
				return true
			else:
				dialogue.append_text("The thorns seem unfathomably prickly and unreasonable, they stare at you, almost as if they are laughing.\n\n")
				dialogue.on_option()
				await get_tree().create_timer(1.5).timeout
	return false

func runShearsDialogue() -> bool:
	dialogue.clear_dialogue()
	dialogue.append_text("\nA pair of shears lay helplessly on the floor\n")
	dialogue.on_option()
	await get_tree().create_timer(0.5).timeout
	#Options
	var options: Array[String] = ["Grab the Shears", "Investigate further"]
	player_choice.show_options(options)
	var choice: int = await player_choice.ask(options)
	
	match choice:
		0:
			dialogue.append_text("You grab the shears that are just laying there. If you were expecting a fight, there is not one to be found here.\n\n")
			dialogue.on_option()
			await get_tree().create_timer(1.0).timeout
			return true
		1:
			dialogue.append_text("A pair of shears lay helplessly on the floor. The grass around it is being crushed slightly, but not unnaturally.\n")
			dialogue.on_option()
			await get_tree().create_timer(1.0).timeout
			
	var options1: Array[String] = ["Grab the Shears", "Investigate EVEN further"]
	player_choice.show_options(options1)
	var choice1: int = await player_choice.ask(options1)
	
	match choice1:
		0:
			dialogue.append_text("You grab the shears that are just laying there. If you were expecting a fight, there is not one to be found here.\n\n")
			dialogue.on_option()
			await get_tree().create_timer(1.0).timeout
			return true
		1:
			dialogue.append_text("Yeah... So... the shears continue laying on the grass. They look like they almost want to be picked up by you.\n")
			dialogue.on_option()
			await get_tree().create_timer(1.0).timeout
	
	var options2: Array[String] = ["Grab the Shears, finally", "Investigate EVEN EVEN further"]
	player_choice.show_options(options2)
	var choice2: int = await player_choice.ask(options2)
	
	match choice2:
		0:
			dialogue.append_text("You grab the shears that are just laying there. If you were expecting a fight, there is not one to be found here.\n\n")
			dialogue.on_option()
			await get_tree().create_timer(1.0).timeout
			return true
		1:
			dialogue.append_text("Alright, it's a pair of shears on the grass. I'm not really sure what else there is to say about it... pick them up to progress I guess?\n")
			dialogue.on_option()
			await get_tree().create_timer(1.0).timeout
	
	var options3: Array[String] = ["Grab the Shears, finally", "Investigate EVEN EVEN EEEEEEEEVVVVVEEEEENNNNN further"]
	player_choice.show_options(options3)
	var choice3: int = await player_choice.ask(options3)
	
	match choice3:
		0:
			dialogue.append_text("You FINALLY grab the shears that are just laying there. If you were expecting a fight, there is not one to be found here.\n\n")
			dialogue.on_option()
			await get_tree().create_timer(1.0).timeout
			return true
		1:
			dialogue.append_text("Okay, this is getting old. It is genuinely JUST a pair of shears on the ground, there is literally nothing else going on here, just a pair of shears laying, alone, on the grass.\n")
			dialogue.on_option()
			await get_tree().create_timer(1.0).timeout
	
	var options4: Array[String] = ["Grab the Shears, finally, for real", "Investigate, because this time something will be different"]
	player_choice.show_options(options4)
	var choice4: int = await player_choice.ask(options4)
	
	match choice4:
		0:
			dialogue.append_text("You finally grab the shears that are just laying there. If you were expecting something else, I don't know what to tell you.\n\n")
			dialogue.on_option()
			await get_tree().create_timer(1.0).timeout
			return true
		1:
			dialogue.append_text("Nope! That's it, I give up, you CLEARLY do not want to pick these up, so I'll make it easy for you. Poof! They're gone! I really don't understand what you were expecting to find here but they're gone now!\n")
			dialogue.on_option()
			await get_tree().create_timer(1.0).timeout
			
			
	return false

func runGemsDialogue() -> bool:
	dialogue.clear_dialogue()
	dialogue.append_text("\nA burlap sack lies behind the red walls of a barn, something blue glittering from within its depths.\n")
	dialogue.on_option()
	await get_tree().create_timer(0.5).timeout
	#Options
	var options: Array[String] = ["Take the sack", "Investigate its contents"]
	player_choice.show_options(options)
	var choice: int = await player_choice.ask(options)
	
	match choice:
		0:
			dialogue.append_text("You grab the sack, staggering a bit beneath its weight. Clearly you need to work on your upper arm strength. GEMS RECEIVED!\n\n")
			dialogue.on_option()
			await get_tree().create_timer(1.0).timeout
			return true
		1:
			dialogue.append_text("Curious, you open the sack a bit wider to be met with the sight of a dazzling heap of jewels. Sapphires, from the look of it - they glisten with a deep blue shine and make a gentle clinking sound as they jostle against one another. Either sapphires are common currency around these parts, or the pig you met earlier must be massively loaded.\n\n")
			dialogue.on_option()
			await get_tree().create_timer(1.0).timeout
			
	var options1: Array[String] = ["Take the sack", "Dig to the bottom of the sack"]
	player_choice.show_options(options1)
	var choice1: int = await player_choice.ask(options1)
	
	match choice1:
		0:
			dialogue.append_text("You grab the sack, staggering a bit beneath its weight. Clearly you need to work on your upper arm strength. GEMS RECEIVED!\n\n")
			dialogue.on_option()
			await get_tree().create_timer(1.0).timeout
			return true
		1:
			dialogue.append_text("Surely there can't just be twenty pounds of jewels lying around in here, can there? You plunge your hands into the sack, digging through its contents to discover that . . . nope, there really is twenty pounds of jewels buried in this inconspicous heap of burlap. Good Lord.\n\n")
			dialogue.on_option()
			await get_tree().create_timer(1.0).timeout
			dialogue.append_text("Except . . . your webbed fingers come into contact with something at the very bottom of the sack that has a strange, rough texture, akin to very worn parchment. A faint shiver of apprehension passes through you as you touch it.\n\n")
			dialogue.on_option()
			await get_tree().create_timer(1.0).timeout
	
	var options2: Array[String] = ["Leave the paper alone and take the sack", "Pull out the paper"]
	player_choice.show_options(options2)
	var choice2: int = await player_choice.ask(options2)
	
	match choice2:
		0:
			dialogue.append_text("Probably best to just let it alone, then - curiosity killed the frog and all. You withdraw your arm and grab the sack, staggering a bit beneath its weight. Clearly you need to work on your upper arm strength. GEMS RECEIVED!\n\n")
			dialogue.on_option()
			await get_tree().create_timer(1.0).timeout
			return true
		1:
			dialogue.append_text("You withdraw your arm from the sack and look at the fragment of parchment gripped in your hand. Written on it in crude red handwriting, the scrawl of a child's crayon, is four words:\n\n")
			dialogue.on_option()
			await get_tree().create_timer(1.0).timeout
			dialogue.append_text("YOU SHOULDN'T BE HERE\n\n")
			dialogue.on_option()
			await get_tree().create_timer(1.0).timeout
			dialogue.append_text("You drop it, alarmed, and it flutters to the ground - but unexpectedly, it vanishes before ever touching earth. Then there is nothing but the sack, lying innocently before you.\n\n")
			dialogue.on_option()
			await get_tree().create_timer(1.0).timeout
			dialogue.append_text("You blink hard. Now is not the time to start hallucinating.\n\n")
			dialogue.on_option()
			await get_tree().create_timer(1.0).timeout
	
	var options3: Array[String] = ["Take the sack"]
	player_choice.show_options(options3)
	var choice3: int = await player_choice.ask(options3)
	
	match choice3:
		0:
			dialogue.append_text("At last, your ill-judged investigation over with, you grab the sack, staggering a bit beneath its weight. Clearly you need to work on your upper arm strength. GEMS RECEIVED!\n\n")
			dialogue.on_option()
			await get_tree().create_timer(1.0).timeout
			return true
			
	return true

func runBarnDialogue() -> void:
	dialogue.clear_dialogue()
	dialogue.append_text("\nA barn with cherry red walls stands before you, bright and cheery-looking. In fact, it almost looks like it has something to tell you.\n\n")
	dialogue.on_option()
	await get_tree().create_timer(1.0).timeout
	#Options
	var options: Array[String] = ["Try to find out what the barn wants to tell you", "Let it be for now"]
	player_choice.show_options(options)
	var choice: int = await player_choice.ask(options)
	
	match choice:
		0:
			#Check Wisdom
			if await skill_check_manager.CheckSkill(0, 2):
				dialogue.append_text("You lean it close - even closer - close enough to rest your ear against the cool wooden wall of the barn, and you listen hard.\n\n")
				dialogue.on_option()
				await get_tree().create_timer(1.5).timeout
				dialogue.append_text("The wind rattles through the timbers with a faint moan, the smell of fresh paint flooding your nostrils. A whisper of mice scurrying through the rafters, and the patient footsteps of a cat. Flowers rustle in a glass on the windowsill.\n\n")
				dialogue.on_option()
				await get_tree().create_timer(1.5).timeout
				dialogue.append_text("Nothing much you can make out with clarity but the certainty of this - it is happy that you're here.\n\n")
				dialogue.on_option()
				await get_tree().create_timer(1.5).timeout
			else:
				dialogue.append_text("What are you going on about? Barns don't talk, and the fact that you're expecting this one to is mildly concerning.\n\n")
				dialogue.on_option()
				await get_tree().create_timer(1.5).timeout
		1:
			dialogue.append_text("A mystery for another day, perhaps.\n\n")
			dialogue.on_option()
			await get_tree().create_timer(1.5).timeout
