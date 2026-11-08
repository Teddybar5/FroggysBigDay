extends ColorRect

func _ready() -> void:
	_update_fraction()
	resized.connect(_update_fraction)
	get_viewport().size_changed.connect(_update_fraction)

func _update_fraction() -> void:
	var vp := get_viewport_rect().size
	(material as ShaderMaterial).set_shader_parameter("rect_screen_fraction", size / vp)
