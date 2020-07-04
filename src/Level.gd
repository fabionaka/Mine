extends Node2D

enum Space {
	WOODS,
	MINE
}
enum Bus {
	MASTER,
	CAVE,
	CAVEFX
}
onready var player = get_node("Actors/Player")

# Called when the node enters the scene tree for the first time.
#func _ready():
#	setup_bgx(Bus.MASTER, "res://sounds/bg/woods-sound-bg.ogg")
	

#func setup_bgx(set_bus, snd):
#	player.bg_snd_player.playing = true
#	player.bg_snd_player.autoplay = true
#	match set_bus :
#		Bus.MASTER :
#			player.bg_snd_player.bus =  "Master"
#			player.snd_player.bus = "Master"
#		Bus.CAVE :
#			player.bg_snd_player.bus =  "Cave"
#			player.snd_player.bus = "CaveMinus"
#
#	player.bg_snd_player.stream = load(snd)
	

func _play_new_bg(from, to):
	match to :
		Space.WOODS :
			player.setup_bgx(Bus.MASTER, "res://sounds/bg/woods-sound-bg.ogg")
		Space.MINE :
			player.setup_bgx(Bus.CAVE, "res://sounds/bg/cave-drip-bg.ogg")


func give_resources(pos : Vector2, ammount : int, type) -> void :
	var resource = load("res://objects/resources/Resource.tscn")
	var layer = get_node("Layer2")
	var i = 0
	
	while i < ammount :
		var rnd = RandomNumberGenerator.new()
		rnd.randomize()
		var linear_velocity = Vector2(rnd.randf_range(-20,20), -50)
		var instantiated = resource.instance()
		instantiated.config_material = type
		instantiated.global_position = pos
		instantiated.linear_velocity = linear_velocity
		layer.add_child(instantiated)
		i += 1
