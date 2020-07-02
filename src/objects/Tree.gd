extends Node2D

signal tree_cutted

enum Stages {
	SEEDLING
	SAPLING,
	MATURE,
	DECLINE
	SNAG,
}
onready var level = get_tree().get_root().get_node("Game/Level")

func _physics_process(delta):
	if Input.is_action_just_pressed("dig"):
		cut_down_tree()

# Called when the node enters the scene tree for the first time.
func _ready():
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
	$AnimationPlayer.play("Cutting")
	
	

func hide_tree():
	$Polygon2D.hide()
	var rnd = RandomNumberGenerator.new()
	rnd.randomize()
	emit_signal("tree_cutted", Vector2(global_position.x, global_position.y + -10), rnd.randf_range(5, 10), "wood")
	queue_free()
