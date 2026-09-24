extends RichTextLabel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(10):
		text += "\n"
	return

func on_option() -> void:
	var tween: Tween = create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	var scroll: ScrollBar = get_v_scroll_bar()
	var v: float = scroll.get_value()
	var m: float = scroll.get_max()
	tween.tween_method(scroll.set_value, v, m, 0.55)
	return
