extends "res://objects/Object.gd"

signal turned_on
signal turned_off
signal fuel_added

export (int) var fuel = 0 setget add_fuel

onready var light = $Light2D
onready var local_energy : float = light.energy
onready var local_texture_scale : float = light.texture_scale
onready var animation_player= $AnimationPlayer

func _ready():
	_turn_on()


func _flickering():
	var rnd_size = RandomNumberGenerator.new()
	rnd_size.randomize()
	var light_size = rnd_size.randf_range(0.9, 1.1)
	light.texture_scale = local_texture_scale * light_size
	light.energy = local_energy * light_size / 1.2


func _turn_on() -> void:
	print("_turn_on ",light.enabled)
	light.enabled = true
	animation_player.play("Light")
	
	
func _turn_off() -> void:
	print("_turn_off ",light.enabled)
	light.enabled = false
	animation_player.play("Off")
	

func add_fuel(value) :
	fuel += value
	emit_signal("fuel_added", value)

func do_action() :
	if light.enabled :
		_turn_off()
	elif !light.enabled :
		_turn_on()
