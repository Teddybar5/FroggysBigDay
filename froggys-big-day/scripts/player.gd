class_name Player extends CharacterBody2D

var cardinal_direction : Vector2 = Vector2.DOWN
var direction : Vector2 = Vector2.ZERO
var flowers : int = 0

#Stat Variables
@export var wisdom : int = 1 
@export var empathy : int = 1 
@export var courage : int = 1
@export var strength : int = 1
var stats: Array[int] = [wisdom, empathy, courage, strength]

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var state_machine : PlayerStateMachine = $StateMachine
@onready var flower_display: Label = $"../CanvasLayer/FlowerDisplay"



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	state_machine.Initialize(self)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	direction = Vector2(Input.get_axis("left", "right"), Input.get_axis("up", "down")).normalized()
	pass

func _physics_process(delta: float) -> void:
	move_and_slide()
	
func run_ability_check(ability: int, min : int) -> bool:
	stats = [wisdom, empathy, courage, strength]
	if stats[ability] >= min:
		return true
	return false
	
func SetDirection() -> bool:
	var new_dir : Vector2 = cardinal_direction
	if direction == Vector2.ZERO:
		return false
		
	if direction.y == 0:
		new_dir = Vector2.LEFT if direction.x < 0 else Vector2.RIGHT
	elif direction.x == 0:
		new_dir = Vector2.UP if direction.y < 0 else Vector2.DOWN
		
	if new_dir == cardinal_direction:
		return false
	cardinal_direction = new_dir
	sprite_2d.scale.x = -1 if cardinal_direction == Vector2.LEFT else 1
	return true

func UpdateAnimation(state : String) -> void:
	animation_player.play(state + "_" + AnimDirection())
	pass

func AnimDirection() -> String:
	if cardinal_direction == Vector2.DOWN:
		return "down"
	elif cardinal_direction == Vector2.UP:
		return "up"
	else:
		return "side"
		
func UpdateFlowers(num : int):
	flowers = flowers + 1
	flower_display.UpdateText()
