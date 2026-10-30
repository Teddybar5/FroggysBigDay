extends Node

signal quests_changed

var quests: Array[Quest] = []

func _ready() -> void:
	load_all_quests("res://quests/data/")

func load_all_quests(path: String) -> void:
	var dir := DirAccess.open(path)
	if dir == null:
		push_error("Could not open quest folder: " + path)
		return
	for file_name in dir.get_files():
		print("Found file: ", file_name)
		file_name = file_name.trim_suffix(".remap")
		if file_name.ends_with(".tres"):
			var quest := load(path + file_name) as Quest
			if quest:
				quests.append(quest)
			else:
				push_warning("Not a Quest resource: " + file_name)
		else:
			push_warning("Skipped (not .tres): " + file_name)

func get_active_quests() -> Array[Quest]:
	return quests.filter(func(q: Quest): return not q.completed)

func complete_quest(id: String) -> void:
	for q in quests:
		if q.id == id:
			q.completed = true
			quests_changed.emit()
			return
