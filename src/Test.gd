extends Node2D

onready var inventory_test = Inventory.new()
onready var mat_test = GameMaterials.new()
onready var rnd = RandomNumberGenerator.new()

func _process(delta):
	if Input.is_action_just_pressed("action"):
		
		rnd.randomize()
		var t = rnd.randi_range(1,3)
		var mat = null
		if t == 1:
			mat = mat_test.get_game_material_by_name("wood")
		if t == 2:
			mat = mat_test.get_game_material_by_name("rock")
		if t == 3:
			mat = mat_test.get_game_material_by_name("water")
			
		inventory_test.add_item_to(mat, 1)
