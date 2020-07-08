class_name GameMaterials

var materials = [
	{"name": "wood", "icon": "res://assets/resouce/r-01-wood.png", "lifetime": 12,"value":50,},
	{"name": "rock", "icon": "res://assets/resouce/r-02-rock.png", "lifetime": 5,"value": 25,},
	{"name": "gold", "icon": "res://assets/resouce/r-03-gold.png", "lifetime": 7,"value": 100},
	{"name": "diamond", "icon": "res://assets/resouce/r-03-gold.png", "lifetime": 7,"value": 100},
	{"name": "water", },
]
var materials_name : Array;

func _init() : 
	
	for m in materials : 
		if not m.has("stackeable") :
			m.stackeable = true
			

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
