extends RigidBody2D

export (String, "wood", "rock", "water") var config_material
export (String, FILE) var default_sprite

var game_material

onready var game_materials = GameMaterials.new()

func _ready():
	
	if config_material != null :
		setup_object(config_material)
	else :
		queue_free()


func setup_object(name : String) :
	# Get game material
	game_material =  game_materials.get_game_material_by_name(name)
	
	# Setup sprite
	if game_material.has("icon") :
		$Sprite.texture = load(game_material.icon)
	else :
		$Sprite.texture = load(default_sprite)
		
	# Setup Shapes 
	
	var shape = CircleShape2D.new()
	shape.radius = $Sprite.get_rect().size.x /2
	$CollisionShape2D.shape = shape
