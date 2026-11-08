class_name Idle extends State

@onready var walk: Walk = $"../Walk"


## what happens when the player enters this state
func Enter() -> void:
	player.UpdateAnimation("idle")
	pass
	
##what happens when the player exits the state
func Exit() -> void:
	pass
	
	
func Process(_delta : float) -> State:
	if player.direction != Vector2.ZERO:
		return walk
	
	player.velocity = Vector2.ZERO
	return null

func Physics(_delta : float) -> State:
	return null
	
func HandleInput(event : InputEvent) -> State:
	return null
