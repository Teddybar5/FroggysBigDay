extends Node

signal quests_changed
signal quest_accepted(quest: Quest)

var all_quests: Dictionary = {}          # id -> Quest, everything in the game
var active_quests: Array[Quest] = []     # quests the player currently has

func _ready() -> void:
	load_all_quests("res://quests/data/")

func load_all_quests(path: String) -> void:
	var dir := DirAccess.open(path)
	if dir == null:
		push_error("Could not open quest folder: " + path)
		return
	for file_name in dir.get_files():
		file_name = file_name.trim_suffix(".remap")
		if file_name.ends_with(".tres"):
			var quest := load(path + file_name) as Quest
			if quest:
				all_quests[quest.id] = quest

func accept_quest(id: String) -> void:
	var quest: Quest = all_quests.get(id)
	if quest == null:
		push_warning("No quest with id: " + id)
		return
	if quest in active_quests or quest.completed:
		return
	active_quests.append(quest)
	quests_changed.emit()
	quest_accepted.emit(quest)

func complete_quest(id: String) -> void:
	var quest: Quest = all_quests.get(id)
	if quest == null:
		return
	quest.completed = true
	active_quests.erase(quest)
	quests_changed.emit()

func is_active(id: String) -> bool:
	var quest: Quest = all_quests.get(id)
	return quest != null and quest in active_quests
