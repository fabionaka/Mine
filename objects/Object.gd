extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var teste = InputMap.get_action_list("action")
	print(teste[0].scancode)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
