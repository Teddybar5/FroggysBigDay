extends Control

@onready var flower_display: Label = $"."
var flowers : int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	flower_display.text = "Flowers: 0"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func UpdateText() -> void:
	flowers = flowers + 1
	flower_display.text = "Flowers: " + str(flowers)
	pass
