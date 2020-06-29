extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	var rnd = RandomNumberGenerator.new()
	rnd.randomize()
	var tm = rnd.randf_range(0,0.5)
	
	var position_y = rnd.randf_range(0,10)
	position.y += position_y
			
			
	var t = Timer.new()
	t.set_wait_time(tm)
	t.set_one_shot(true)
	self.add_child(t)
	t.start()
	yield(t, "timeout")
	$AnimationPlayer.play("Wind-1")
	t.queue_free()
	
	
