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
var current_stage = Stages.MATURE setget set_current_stage
var life_cycle_conf = [
	{"name":Stages.SEEDLING,"to": Stages.SAPLING, "time": 3, "node": "Stages/Seedling", "to_node": "Stages/Sapling",},
	{"name":Stages.SAPLING,"to": Stages.MATURE, "time": 3, "node": "Stages/Sapling", "to_node": "Stages/Mature",},
	{"name":Stages.MATURE,"to": Stages.DECLINE, "time": 3, "node": "Stages/Mature", "to_node": "Stages/Decline",},
	{"name":Stages.DECLINE,"to": Stages.SNAG, "time": 3, "node": "Stages/Decline", "to_node": "Stages/Snag",},
	{"name":Stages.SNAG,"to": Stages.TRUNK, "time": 3, "node": "Stages/Snag", "to_node": "Stages/Trunk",},
	{"name":Stages.TRUNK,"to": Stages.SEEDLING, "time": 3, "node": "Stages/Trunk", "to_node": "Stages/Seedling"},
]
onready var level = get_tree().get_root().get_node("Game/Level")
onready var tree_stages = get_node("Stages")

func _physics_process(delta):
	
	if Input.is_action_just_pressed("dig"):
		cut_down_tree()

# Called when the node enters the scene tree for the first time.
func _ready():
	
	# inicia ciclo de vida da árvore
	for s in life_cycle_conf : 
		if s.name == current_stage:
			set_current_stage(s)
	
	
	var rnd = RandomNumberGenerator.new()
	rnd.randomize()
	var tm = rnd.randf_range(0,0.8)
	
	var position_y = rnd.randf_range(0,5)
	position.y += position_y
			
			
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
	
	
	

func cut_down_tree():
	print(current_stage)
	if current_stage == Stages.MATURE :
		$AnimationPlayer.play("Cutting")
	

func hide_tree():
	$Stages/Mature/Polygon2D.hide()
	var rnd = RandomNumberGenerator.new()
	rnd.randomize()
	emit_signal("tree_cutted", Vector2(global_position.x, global_position.y + -10), rnd.randf_range(5, 10), "wood")
	current_stage = Stages.TRUNK
	queue_free()

func set_current_stage(stage):
	var target_node = get_node(stage.to_node)
	var current_node = get_node(stage.node)

	current_node.hide()
	target_node.show()
	current_stage = stage.to
	
	do_life_cicle()

func do_life_cicle():
	var data = null
	for lf in life_cycle_conf :
		if lf.name == current_stage : 
			data = lf
			
	var tree_timer = Timer.new()
	add_child(tree_timer)
	tree_timer.start(data.time)
	
	yield(tree_timer,"timeout")
	set_current_stage(data)
	tree_timer.queue_free()
	
