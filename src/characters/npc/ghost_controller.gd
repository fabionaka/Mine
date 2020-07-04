extends GenericController

var target = null
var hit
var collision_light 
var touched_light = false

func _init(character: Character, parent: KinematicBody2D, init_state, anim_state).(character, parent,  init_state, anim_state) :
	collision_light = local_parent.get_node("Interaction")
	var col_shape = local_parent.get_node("Interaction/CollisionShape2D")
	var shape = CapsuleShape2D.new()
	shape.radius = 6
	shape.height = 10
	col_shape.shape = shape
	
	
func control(delta, velocity : Vector2, _ray : RayCast2D): 
	if !target :
		target = local_parent.get_tree().get_nodes_in_group("player")[0]
	
		
	if target :
		if is_on_light():
			if !target :
				return Vector2.ZERO
			velocity = (target.global_position - local_parent.global_position) * (delta * 50) * -1
			return  velocity
		velocity = (target.global_position - local_parent.global_position) * (delta * 15)
	
	
	
	return velocity
	

func is_on_light():
	for i in collision_light.get_overlapping_areas() :
		if i.name == "Spook" and i.get_parent().get_node("Light2D").enabled :
			if touched_light :
				local_parent.took_hit(0.5)
			touched_light = true
			return true
	
	touched_light = false
	return false
