extends Node
class_name GenericController 

enum {
	MOVE, DIG
}
var local_character : Character setget set_character, get_character
var input_vector : Vector2 = Vector2.ZERO
var state setget set_state,get_state
var animation_state

func _init(character : Character, init_state, anim_state):
	local_character = character
	state = init_state
	animation_state = anim_state

func set_character(character : Character):
	local_character = character
func get_character():
	return local_character
func set_state(value):
	state = value
func get_state():
	return state

func _ready():
	print(local_character)
	
func control(_delta, velocity : Vector2) -> Vector2:
	return velocity
	
func return_to_move_state() -> void:
	state = MOVE
	
func rotate_sprite() -> int:
	return 1
