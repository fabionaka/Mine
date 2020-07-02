extends "res://objects/Object.gd"

onready var level = get_tree().get_root().get_node("Game/Level")

func do_action() -> void:
	var game_resources = GameMaterials.new()
	var rnd = RandomNumberGenerator.new()
	
	for gm in game_resources.materials :
		rnd.randomize()
		var total = rnd.randf_range(2, 6)
		var i = 0
		
		while i < total :
			var game_recource = load("res://objects/resources/Resource.tscn").instance()
			game_recource.config_material = gm.name
			game_recource.global_position = global_position
			game_recource.linear_velocity = Vector2(rnd.randf_range(-6, 6), -100)
			level.add_child(game_recource)
			
			i += 1
			
