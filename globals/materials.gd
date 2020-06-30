class_name GameMaterials

var materials = [
	{"name": "wood", "icon": "res://assets/resouce/r-01-wood.png", "lifetime": 35,},
	{"name": "rock", "icon": "res://assets/resouce/r-02-rock.png", "lifetime": 15,},
	{"name": "water", },
]
var materials_name : Array;

func get_materials_name() -> Array :
	for m in materials : 
		materials_name.append(m.name)
	return materials_name

func get_game_material_by_name(name):
	var mat 
	for m in materials : 
		if m.name == name :
			mat = m
	return mat
