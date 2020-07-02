extends "res://characters/character_template.gd"


export (bool) var has_interaction = false
export (int) var interation_radius

var _player_group


func _ready():
	$AnimationPlayer.play("Idle")
	
	if has_interaction :
		var shape = CircleShape2D.new()
		shape.radius = 10
		if interation_radius :
			shape.radius = interation_radius
			
		$Interaction/CollisionShape2D.shape = shape
	


func _add_animation():
	pass

func _modulate_sprite() -> void:
	var rand = RandomNumberGenerator.new()
	rand.randomize()
	$Sprite.self_modulate = Color(1,1,1,rand.randf_range(0.5, 1) )

