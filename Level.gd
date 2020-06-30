extends Node2D

enum Space {
	WOODS,
	MINE
}
enum Bus {
	MASTER,
	CAVE
}

onready var bg_snd_player = $BackgroundSndEfx
onready var player = get_node("Actors/Player")

# Called when the node enters the scene tree for the first time.
func _ready():
	setup_bgx(Bus.MASTER, "res://sounds/bg/woods-sound-bg.ogg")
	

func setup_bgx(set_bus, snd):
	bg_snd_player.playing = true
	bg_snd_player.autoplay = true
	match set_bus :
		Bus.MASTER :
			bg_snd_player.bus =  "Master"
		Bus.CAVE :
			bg_snd_player.bus =  "Cave"
	
	bg_snd_player.stream = load(snd)
	

func _play_new_bg(from, to):
	
	match to :
		Space.WOODS :
			setup_bgx(Bus.MASTER, "res://sounds/bg/woods-sound-bg.ogg")
			player.snd_player.bus = "Master"
		Space.MINE :
			setup_bgx(Bus.CAVE, "res://sounds/bg/cave-drip-bg.ogg")
			player.snd_player.bus = "CaveMinus"
