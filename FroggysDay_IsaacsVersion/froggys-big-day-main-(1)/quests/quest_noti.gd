extends CanvasLayer

@onready var panel: PanelContainer = $Panel
@onready var label: Label = $Panel/MarginContainer/Label

var tween: Tween

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS  # still animates if the game is paused
	panel.modulate.a = 0.0                   # start invisible
	QuestManager.quest_accepted.connect(_on_quest_accepted)

func _on_quest_accepted(quest: Quest) -> void:
	label.text = "New Quest: " + quest.title

	# If another popup is still showing, restart the animation
	if tween:
		tween.kill()

	tween = create_tween()
	tween.tween_property(panel, "modulate:a", 1.0, 0.1)  # fade in
	tween.tween_interval(2.0)                            # stay visible
	tween.tween_property(panel, "modulate:a", 0.0, 0.5)  # fade out
