extends Node
class_name GenericController 

enum {
	MOVE, DIG, JUMP, FALL
}



var local_character : Character setget set_character, get_character
var input_vector : Vector2 = Vector2.ZERO
var state setget set_state,get_state
var animation_state
var local_parent : KinematicBody2D

var mining
var jumping : bool = true

func _init(character : Character, parent: KinematicBody2D, init_state, anim_state):
	local_character = character
	state = init_state
	animation_state = anim_state
	local_parent = parent

func set_character(character : Character):
	local_character = character
func get_character():
	return local_character
func set_state(value) -> void:
	state = value
func get_state():
	return state

func _ready():
	pass
	
func control(_delta, velocity : Vector2, _ray : RayCast2D) -> Vector2:
	return velocity

	
func return_to_move_state() -> void:
	state = MOVE
	
func rotate_sprite(_val) -> int:
	
	if local_parent.look_at_player :
		var _player_group = local_parent.get_tree().get_nodes_in_group("player")
		if _player_group.size() <1 :
			return 1
		
		if local_parent.global_position.x - _player_group[0].global_position.x > 0 :
			return -1
		else : 
			return 1
	
	return 1
