extends KinematicBody2D

enum {
	MOVE, DIG
}

export (Resource) var character_resource
export (Resource) var controller_resource
export (Resource) var minig_resource

var velocity = Vector2.ZERO
var state = MOVE

onready var animation_player = $AnimationPlayer 
onready var animation_tree = $AnimationTree
onready var animation_state = animation_tree.get("parameters/playback")
onready var sprite = $Sprite
onready var foot_colider = $FootColider

onready var character = character_resource.new()
onready var controller = controller_resource.new(character, MOVE, animation_state)
onready var tile_manager = TileManager.new()


func _ready():
	if is_instance_valid(character) : 
		# Start animation
		animation_tree.active = true
		
		# load Sprite texture
		sprite.texture = load(character.get_character_sprite())

		# Setup camera (If exists)
		if character.get_active_camera() : 
			var scene_camera = Camera2D.new()
			scene_camera.current = character.get_active_camera()
			scene_camera.zoom = character.camera_zoom
			self.add_child(scene_camera)

		# Configure the collison objects for the character
		if not is_instance_valid(character.get_foot_collider_shape()):
			var foot_shape = RectangleShape2D.new()
			var f_height = sprite.get_rect().size.y / 3
			var f_pos_y = (sprite.get_rect().size.y/2) - f_height
			foot_shape.extents = Vector2(7,f_height)
			foot_colider.shape = foot_shape
			foot_colider.position.y += f_pos_y


func _physics_process(delta):
	velocity = controller.control(delta, velocity)
	rotate_sprite()
	
	velocity = move_and_slide(velocity)
	
func return_to_move_state() -> void :
	controller.return_to_move_state()
	
func start_mining () -> void :
	
	var bodies = $Sprite/MinigArea.get_overlapping_bodies();
	var tile_map = null
	for b in bodies :
		if b.get_class() == "TileMap":
			tile_map = b
			if not is_instance_valid(tile_manager.get_tile_map()) :
				tile_manager.set_tile_map(b)

	if is_instance_valid(tile_map):
		var mine_direction = $Sprite.scale.x
		var tile_position = tile_manager.tile_map.world_to_map($Sprite/MinigArea.global_position)
		
		tile_manager.mine_tile(tile_position, mine_direction)
		#tile_manager.mine_tile(tile_position, mine_direction)
#
#
#
#		# block de mina
#		tile_manager.tile_map.set_cell(tile_pos.x, tile_pos.y, 18)
#		tile_manager.tile_map.set_cell(tile_pos.x, (tile_pos.y -1), 18)
#
#		# block teto
#		tile_manager.tile_map.set_cell(tile_pos.x, (tile_pos.y -2), 6)
#
#		# block chao
#		tile_manager.tile_map.set_cell(tile_pos.x, (tile_pos.y +1), 1)
#
#
#		# block da frente vazio
#		if tile_manager.tile_map.get_cell((tile_pos.x - 2), tile_pos.y) == 18 || tile_manager.tile_map.get_cell((tile_pos.x - 2), tile_pos.y) == 17 :
#			pass
#		else :
#			# block lateral
#			tile_manager.tile_map.set_cell((tile_pos.x - 1), (tile_pos.y), 4)
#			tile_manager.tile_map.set_cell((tile_pos.x - 1), (tile_pos.var tile_pos = tile_manager.tile_map.world_to_map($Sprite/MinigArea.global_position)
#
#
#
#		# block de mina
#		tile_manager.tile_map.set_cell(tile_pos.x, tile_pos.y, 18)
#		tile_manager.tile_map.set_cell(tile_pos.x, (tile_pos.y -1), 18)
#
#		# block teto
#		tile_manager.tile_map.set_cell(tile_pos.x, (tile_pos.y -2), 6)
#
#		# block chao
#		tile_manager.tile_map.set_cell(tile_pos.x, (tile_pos.y +1), 1)
#
#
#		# block da frente vazio
#		if tile_manager.tile_map.get_cell((tile_pos.x - 2), tile_pos.y) == 18 || tile_manager.tile_map.get_cell((tile_pos.x - 2), tile_pos.y) == 17 :
#			pass
#		else :
#			# block lateral
#			tile_manager.tile_map.set_cell((tile_pos.x - 1), (tile_pos.y), 4)
#			tile_manager.tile_map.set_cell((tile_pos.x - 1), (tile_pos.y -1), 4)
	
func rotate_sprite() -> void:
	sprite.scale.x = controller.rotate_sprite(sprite.scale.x)
