extends CanvasLayer

@onready var panel: Control = $Panel
@onready var quest_list: ItemList = $Panel/MarginContainer/VBoxContainer/HSplitContainer/QuestList
@onready var close_button: Button = $Panel/MarginContainer/VBoxContainer/CloseButton

# New: details panel references
@onready var quest_name_label: Label = $Panel/MarginContainer/VBoxContainer/HSplitContainer/QuestDetails/QuestName
@onready var description_label: RichTextLabel = $Panel/MarginContainer/VBoxContainer/HSplitContainer/QuestDetails/Description
@onready var objectives_box: VBoxContainer = $Panel/MarginContainer/VBoxContainer/HSplitContainer/QuestDetails/Objectives


func _ready() -> void:
	#Keep working while the game is paused
	process_mode = Node.PROCESS_MODE_ALWAYS
	panel.hide()
	close_button.pressed.connect(close_menu)
	quest_list.item_selected.connect(_on_quest_selected)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_quest_menu"):
		toggle_menu()
		get_viewport().set_input_as_handled()

func toggle_menu() -> void:
	if panel.visible:
		close_menu()
	else:
		open_menu()

func open_menu() -> void:
	refresh_quest_list()
	panel.show()
	await get_tree().process_frame
	print("List size: ", quest_list.size)
	print("Max columns: ", quest_list.max_columns)
	print("Row 0 rect: ", quest_list.get_item_rect(0))
	print("Row 1 rect: ", quest_list.get_item_rect(1))
	get_tree().paused = true

func close_menu() -> void:
	panel.hide()
	get_tree().paused = false

#rebuild the list from QuestManager
func refresh_quest_list() -> void:
	quest_list.clear()
	for quest in QuestManager.quests:
		var index := quest_list.add_item(quest.title)
		quest_list.set_item_metadata(index, quest)
	clear_details()
		
	#Auto-select the first quest if there is one
	if quest_list.item_count > 0:
		quest_list.select(0)
		_on_quest_selected(0)

#shows the selected quest instead of just printing
func _on_quest_selected(index: int) -> void:
	var quest: Quest = quest_list.get_item_metadata(index)
	show_quest(quest)

#fill in the details panel
func show_quest(quest: Quest) -> void:
	quest_name_label.text = quest.title
	description_label.text = quest.description

	#Remove old objective labels
	for child in objectives_box.get_children():
		child.queue_free()

	#Add one label per objective
	for objective in quest.objectives:
		var label := Label.new()
		label.text = "• " + objective
		label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		objectives_box.add_child(label)

#empty the details panel
func clear_details() -> void:
	quest_name_label.text = ""
	description_label.text = ""
	for child in objectives_box.get_children():
		child.queue_free()
