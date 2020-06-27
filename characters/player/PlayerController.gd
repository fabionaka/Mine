extends GenericController

func _init(character: Character, init_state, anim_state).(character,  init_state, anim_state) :
  pass

func _ready():
	pass

func control(delta, velocity : Vector2):
	match state:
		MOVE: 
			velocity = move_control(delta, velocity)
		DIG :
			velocity = dig_control(delta)
	return velocity
	
func move_control(delta, velocity : Vector2):
	input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_vector.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up") 
	
	if input_vector != Vector2.ZERO :
		animation_state.travel("Move")
		velocity = velocity.move_toward(input_vector * local_character.max_speed, local_character.max_acceleration * delta)
	else :
		animation_state.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, local_character.friction * delta)
		
	if Input.is_action_just_pressed("dig"):
		state = DIG
		
	return velocity 

func dig_control(delta):
	animation_state.travel("Mine")
	return Vector2.ZERO

func rotate_sprite() -> int:
	var rotation = 1
	if Input.get_action_strength("move_left") - Input.get_action_strength("move_right") != 0 :
		rotation = Input.get_action_strength("move_left") - Input.get_action_strength("move_right")
	return rotation
