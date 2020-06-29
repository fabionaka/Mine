extends "res://characters/character_template.gd"


func _ready():
	$AnimationPlayer.play("Idle")

func _modulate_sprite() -> void:
	var rand = RandomNumberGenerator.new()
	rand.randomize()
	$Sprite.self_modulate = Color(1,1,1,rand.randf_range(0.5, 1) )
