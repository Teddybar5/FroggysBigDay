extends RichTextLabel

@onready var dialogue: RichTextLabel = $"../dialogue"

var _options: Array[String] = []


func _ready() -> void:
	bbcode_enabled = true
	meta_clicked.connect(_on_meta_clicked)


func show_options(options: Array[String]) -> void:
	_options = options
	text = ""
	for i in options.size():
		append_text("[url=%d]%d. %s[/url]\n" % [i, i + 1, options[i]])


func _on_meta_clicked(meta: Variant) -> void:
	dialogue.append_text("\n" + _options[int(meta)] + "\n")
	text = ""
	dialogue.on_option()
