extends GenericController



var prev_v = null

func _init(character: Character, parent: KinematicBody2D, init_state, anim_state).(character, parent,  init_state, anim_state) :
  pass

func _ready():
	pass

func control(delta, velocity : Vector2,ray : RayCast2D): 
	match state:
		MOVE: 
			velocity = move_control(delta, velocity)
		DIG :
			velocity = dig_control(delta)
		FALL :
			velocity = fall_control(delta, velocity)
		JUMP :
			velocity = jump_control(delta, velocity, ray)
			
	if ray.is_colliding() and Input.is_action_just_pressed("move_up") :
		state = JUMP
		
	return velocity
	
func rotate_sprite(val) -> int:
	var rotation = val
	if Input.get_action_strength("move_left") - Input.get_action_strength("move_right") != 0 :
		rotation = Input.get_action_strength("move_left") - Input.get_action_strength("move_right")
	return rotation
	
func move_control(delta, velocity : Vector2) -> Vector2:
	input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	#input_vector.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up") 
	
	if input_vector != Vector2.ZERO :
		animation_state.travel("Move")
		velocity = velocity.move_toward(input_vector * local_character.max_speed, local_character.max_acceleration * delta)
	else :
		animation_state.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, local_character.friction * delta)
		
	if Input.is_action_just_pressed("dig"):
		state = DIG
	if Input.is_action_just_pressed("action"):
		local_parent.do_action()
		
	return velocity 

func dig_control(_delta) -> Vector2:
	var action_area = local_parent.get_node("Sprite/MinigArea")
	var tree
	for a in action_area.get_overlapping_areas() :
		var element = a.get_parent()
		if element.get_groups().has("trees") :
			element.cut_down_tree(local_parent.get_node("Sprite").scale.x * -1)
			
	animation_state.travel("Mine")
	return Vector2.ZERO
	
func fall_control(_delta, velocity : Vector2) -> Vector2:
	velocity.y += 9.8
	return velocity 

func jump_control(_delta, velocity : Vector2, ray) -> Vector2:
	var jump_height = ray.get_children()[0]
	animation_state.travel("JumpStart")
	var vel = velocity
	
	
	if !jump_height.enabled : 
		jump_height.force_raycast_update()
		
	
	if jump_height.is_colliding() and jumping : 
		velocity.y += -15
		jumping = true
	else  : 
		jump_height.enabled = false
		velocity.y += 12
		if velocity.y > 300 :
			velocity.y = 300
		jumping = false
		
	
	if  vel == Vector2.ZERO  or prev_v == velocity.y: 
		local_parent._play_sound("headBump")
		jump_height.enabled = false
		jumping = false
		velocity.y += 20
		
	prev_v = velocity.y
	
	if velocity.y > 0 :
		animation_state.travel("Jump")
		
	if !jumping and ray.is_colliding():
		animation_state.travel("JumpEnd")
		state=MOVE
		jumping = true
		prev_v = null
		
	return velocity 
