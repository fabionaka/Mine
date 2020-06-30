extends Node2D

signal player_crossed

enum {
	WOODS,
	MINE
}
var from
var to

onready var left = $AreaLeft
onready var right = $AreaRight
onready var level = get_tree().get_root().get_node("Game/Level")

func _ready():
	print()
	var connected = connect("player_crossed", level, "_play_new_bg")

func _on_Area2D_body_entered(body):
	if body.get_groups().has("player") :
		if left.overlaps_body(body) and !right.overlaps_body(body) :
			from = WOODS
			to = MINE
		if !left.overlaps_body(body) and right.overlaps_body(body) :
			from = MINE
			to = WOODS
			
		emit_signal("player_crossed", from, to)
