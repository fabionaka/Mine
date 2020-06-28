extends "res://objects/Object.gd"


onready var local_energy : float = $Light2D.energy
onready var local_texture_scale : float = $Light2D.texture_scale
func _ready():
	$AnimationPlayer.play("Light")


func _flickering():
	var rnd_size = RandomNumberGenerator.new()
	rnd_size.randomize()
	var light_size = rnd_size.randf_range(0.9, 1.1)
	$Light2D.texture_scale = local_texture_scale * light_size
	$Light2D.energy = local_energy * light_size / 1.2
