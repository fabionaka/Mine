extends Node2D

export (PackedScene) var element_spawn
export (int) var element_width

var total = 0

onready var spawer_width = $GroundSprite.get_rect().size.x

func _ready():
	
	total = spawer_width / element_width
	var rnd = RandomNumberGenerator.new()
	rnd.randomize()
	
	var elements = rnd.randi_range(1, total)
	var where_to_put = (spawer_width / 2) / total
	
	for e in elements :
		randomize()
#		var tre_position = 
		var tree = element_spawn.instance()
		tree.position.x = rand_range(where_to_put * -1, where_to_put)
		add_child(tree)
