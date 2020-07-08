extends Node2D

enum Stages {
	SPROUT
	LEAFING,
	GROWN,
}

var is_chopping = false
var current_stage  setget set_current_stage
var life_cycle_conf = [
	{"name":Stages.SPROUT,"to": Stages.LEAFING, "time": 10, "node": "Stages/Sprout", "to_node": "Stages/Leafing",},
	{"name":Stages.LEAFING,"to": Stages.GROWN, "time": 10, "node": "Stages/Leafing", "to_node": "Stages/Grown",},
	{"name":Stages.GROWN,"to": Stages.SPROUT, "time": 120, "node": "Stages/Grown", "to_node": "Stages/Sprout",},
]

var has_player_on = false
var target = null

onready var bottomBone = $Skeleton2D/Bone2D
onready var topBone = $Skeleton2D/Bone2D/Bone2D
onready var tween = $Tween
onready var init_pos = topBone.position

func _ready():
	# Setup cycle
	var rnd = RandomNumberGenerator.new()
	# inicia ciclo de vida da árvore
	if !current_stage :
		rnd.randomize()
		current_stage = floor(rnd.randf_range(0, 3))
		
	set_current_stage(_search_stage(current_stage))
	
	animate(topBone.position)

func _process(delta):
	if target :
		follow()
	else :
		animate(topBone.position)


func set_current_stage(stage) -> void:
	var target_node = get_node(stage.to_node)
	var current_node = get_node(stage.node)

	current_node.hide()
	target_node.show()
	
	current_stage = stage.to
	do_life_cicle()


func do_life_cicle() -> void:
	var rnd = RandomNumberGenerator.new()
	rnd.randomize()
	var deflator = rnd.randf_range(0.7, 1.3)
	var data = _search_stage(current_stage)
			
	var tree_timer = Timer.new()
	add_child(tree_timer)
	tree_timer.start(deflator * data.time)
	
	yield(tree_timer,"timeout")
	tree_timer.queue_free()
	
	if is_chopping : 
		return 
		
	set_current_stage(data)


func _search_stage(stage) -> Dictionary:
	var searched
	for i in life_cycle_conf :
		if i.name == stage :
			searched = i
	return searched


func animate(last_pos) :
	if not tween.is_active() : 
		var rnd = RandomNumberGenerator.new()
		rnd.randomize()
		var next_pos = Vector2(init_pos.x, rnd.randf_range(-1,1))
		
		tween.interpolate_property(topBone, "position",
				last_pos, next_pos, 0.2,
				Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		tween.start()
		
		yield(tween, "tween_completed")
		animate(topBone.position)


func follow():
	var target_direction = target.sprite.scale.x * 4 * -1
	if !tween.is_active() and topBone.position.y != target_direction :
		var new_pos = Vector2(3, target_direction)
		tween.interpolate_property(topBone, "position",
				topBone.position, new_pos, 0.1,
				Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		tween.start()


func _on_AreaEffect_body_entered(body):
	if not has_player_on :
		if body.get_groups().has("player") :
			tween.remove_all()
			has_player_on = true
			target = body


func _on_AreaEffect_body_exited(body):
	if has_player_on :
		if body.get_groups().has("player"):
			has_player_on = false
			target = null
			animate(topBone.position)
