extends Node2D
class_name TileManager

var hitable_tiles : Array = [1, 3, 4, 6, 12, 13, 19]
var tile_map : TileMap setget set_tile_map,get_tile_map
var tile_hited : Array
var current_tile = null
# Materiais
# Terra, Pedra, Ferro, Cobre, Prata, Ouro


# quadrante
# quantidade total de hits
# quantidade de hits
# Tipo de tile
func set_tile_map(map) -> void:
	tile_map = map
func get_tile_map() -> TileMap:
	return tile_map

func mine_tile(tile_position : Vector2, direction : int, world_position : Vector2) -> void:
	if hitable_tiles.has(tile_map.get_cell(tile_position.x, tile_position.y)) :
		var tile = {
			"position": tile_position,
			"max_hits": 1,
			"hit": 1,
			"tile_type": tile_map.get_cell(tile_position.x, tile_position.y),
		}
		
		for t in tile_hited :
			if t.position == tile_position and t.tile_type == tile_map.get_cell(tile_position.x, tile_position.y) : 
				current_tile = t
		
		
		if current_tile : 
			if current_tile.hit >= current_tile.max_hits :
				_chage_wall_tile(tile_position, direction, world_position)
				
			else :
				current_tile.hit += 1
		else : 
			tile_hited.append(tile)
	
	

func _chage_to_dig_tile(tile_position: Vector2, _direction,  world_position : Vector2) :
	
	# Tudo isso para gerar 30% de chance de ter um tile com pedrinha
	# TODO: melhorar e retirar daqui
	var rand_f = RandomNumberGenerator.new()
	rand_f.randomize()
	var tile_f = 18
	var chance_f = rand_f.randf_range(0,1)
	if chance_f > 0.7: 
		tile_f = 17
	
	var rand_s = RandomNumberGenerator.new()
	rand_s.randomize()
	var chance_s = rand_s.randf_range(0,1)
	var tile_s = 18
	if chance_s > 0.7: 
		tile_s = 17
	
	tile_map.set_cell(tile_position.x, tile_position.y, tile_f)
	tile_map.set_cell(tile_position.x, tile_position.y -1, tile_s)
	tile_hited.erase(current_tile)
	current_tile = null
	
	# PUFF RESOURCE
	# Feio REFATORAR feito de madrugada
	var puff_res = load("res://globals/puff.tscn")
	var puff = puff_res.instance()
	var puff2 = puff_res.instance()
	print(_direction)
	puff.global_position = world_position + Vector2(_direction * 10, -2)
	puff.rotation = rand_f.randf_range(-360,0)
	
	puff2.global_position = world_position + Vector2(_direction * 10, -18)
	puff2.rotation = rand_s.randf_range(0,360)
	var parent = tile_map.get_parent()
	parent = parent.get_parent()
	parent.add_child(puff)
	parent.add_child(puff2)
	
func _chage_floor_tile(tile_position: Vector2, _direction, world_position : Vector2):
	tile_map.set_cell(tile_position.x, tile_position.y + 1, 1)
	
func _chage_ceiling_tile(tile_position: Vector2, _direction, world_position : Vector2):
	tile_map.set_cell(tile_position.x, tile_position.y - 2, 6)
	
func _chage_wall_tile(tile_position: Vector2, direction, world_position : Vector2):
	# Direção está invertida
	direction = direction * -1 
	var wall_tiles = [3, 4, 12]
	
	var tl = 4
	if direction > 0 :
		tl = 3
		
	
	if wall_tiles.has(tile_map.get_cell(tile_position.x + (direction * 2), tile_position.y)) :
		tile_map.set_cell(tile_position.x + direction , tile_position.y, tl)
		tile_map.set_cell(tile_position.x + direction , tile_position.y -1, tl)
		
	if [17,18].has(tile_map.get_cell(tile_position.x + (direction * 2), tile_position.y)) and ![19,13].has(tile_map.get_cell(tile_position.x, tile_position.y))  :
		tile_map.set_cell(tile_position.x + direction , tile_position.y, 19)
		tile_map.set_cell(tile_position.x + direction , tile_position.y-1, 19)
	
	_chage_to_dig_tile(tile_position, direction, world_position)
	_chage_floor_tile(tile_position, direction, world_position)
	_chage_ceiling_tile(tile_position, direction, world_position)
