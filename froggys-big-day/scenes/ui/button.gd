extends Button

@onready var choices: RichTextLabel = $"../Panel/VBoxContainer/playerChoice"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var options: Array[String] = ["Open the door", "Check the window", "Walk away", "Wait"]
	choices.show_options(options)
	connect("pressed", on_pressed)
	return


# Called every frame. 'delta' is the elapsed time since the previous frame.
func on_pressed() -> void:
	var dialogue: RichTextLabel = $"../Panel/VBoxContainer/dialogue"
	dialogue.append_text("adding some text here\n")
	dialogue.on_option()
	return
