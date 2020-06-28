extends Node2D

export (bool) var possui_acao = false
onready var map_key = InputMap.get_action_list("action")
onready var tecla = OS.get_scancode_string(map_key[0].scancode)


func _ready():
	# Se nao possui ação, remove node desnecessário
	if !possui_acao : 
		$AreaEffect.queue_free()
	
	if possui_acao : 
		pass
