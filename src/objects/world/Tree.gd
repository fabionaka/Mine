extends Node2D

signal tree_cutted

enum Stages {
	SEEDLING
	SAPLING,
	MATURE,
	DECLINE
	SNAG,
	TRUNK,
}

var is_chopping = false
var current_stage  setget set_current_stage
var life_cycle_conf = [
	{"name":Stages.SEEDLING,"to": Stages.SAPLING, "time": 60, "node": "Stages/Seedling", "to_node": "Stages/Sapling",},
	{"name":Stages.SAPLING,"to": Stages.MATURE, "time": 60, "node": "Stages/Sapling", "to_node": "Stages/Mature",},
	{"name":Stages.MATURE,"to": Stages.DECLINE, "time": 60, "node": "Stages/Mature", "to_node": "Stages/Decline",},
	{"name":Stages.DECLINE,"to": Stages.SNAG, "time": 60, "node": "Stages/Decline", "to_node": "Stages/Snag",},
	{"name":Stages.SNAG,"to": Stages.TRUNK, "time": 60, "node": "Stages/Snag", "to_node": "Stages/Trunk",},
	{"name":Stages.TRUNK,"to": Stages.SEEDLING, "time": 60, "node": "Stages/Trunk", "to_node": "Stages/Seedling"},
]
var ready = false

onready var level = get_tree().get_root().get_node("Game/Level")
onready var tree_stages = get_node("Stages")

# Called when the node enters the scene tree for the first time.
func _ready():
	$Stages/Mature.hide()
	add_to_group("trees")
	var rnd = RandomNumberGenerator.new()
	# inicia ciclo de vida da árvore
	if !current_stage :
		rnd.randomize()
		current_stage = floor(rnd.randf_range(0, 5))
		
	set_current_stage(_search_stage(current_stage))
	
	
	
	rnd.randomize()
	var tm = rnd.randf_range(0,0.8)

	var t = Timer.new()
	t.set_wait_time(tm)
	t.set_one_shot(true)
	self.add_child(t)
	t.start()
	yield(t, "timeout")
	$AnimationPlayer.play("Wind-1")
	t.queue_free()

	# Conecta sinal de corte de árvore
	connect("tree_cutted", level, "give_resources")


func cut_down_tree(direction) -> void:
	if current_stage == Stages.MATURE :
		self.scale.x = direction
		is_chopping = true
		$AnimationPlayer.play("Cutting")


func hide_tree() -> void:
	var rnd = RandomNumberGenerator.new()
	rnd.randomize()
	is_chopping = false
	emit_signal("tree_cutted", Vector2(global_position.x, global_position.y + -10), rnd.randf_range(5, 10), "wood")
	get_node("Stages/Mature").hide()
	scale.x = 1
	set_current_stage(_search_stage(Stages.SNAG))


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
