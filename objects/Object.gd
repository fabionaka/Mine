extends Node2D

export (bool) var possui_acao = false
onready var map_key = InputMap.get_action_list("action")
onready var tecla = OS.get_scancode_string(map_key[0].scancode)

	
func _ready():
	# Se nao possui ação, remove node desnecessário
	if !possui_acao : 
		$Informacao.queue_free()
		$AreaEffect.queue_free()


func _setup_action_label()->void:
	$Informacao.visible = true
	var x_pos = $Informacao/Label.rect_size.x - $Sprite.get_rect().size.x / 2
	$Informacao/Label.text = tecla
	$Informacao.rect_position = Vector2(x_pos  * -1, $Sprite.get_rect().size.y * -1)


func _set_shader()->void:
	var material_shader = load("res://shaders/ortline.tres")
	$Sprite.set_material(material_shader)
	var shader = $Sprite.material
	shader.set_shader_param("textureName", $Sprite.texture)
	shader.set_shader_param("textureName_size", $Sprite.texture.get_size())


func _remove_shader()->void:
	$Sprite.material = null


func _on_AreaEffect_body_entered(body):
	if  possui_acao and  body.get_groups().has("player"):
		_setup_action_label()
		_set_shader()


func _on_AreaEffect_body_exited(body):
	if  possui_acao and  body.get_groups().has("player"):
		_remove_shader()
		$Informacao.visible = false
