extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"



func _on_Area2D_body_entered(body):
	body.global_position = Vector2(650, -80)
