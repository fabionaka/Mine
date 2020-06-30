extends KinematicBody2D

enum {
	MOVE, DIG, JUMP, FALL
}

export (Resource) var character_resource
export (Resource) var controller_resource
export (Resource) var minig_resource
export (bool) var look_at_player = false

var velocity = Vector2.ZERO
var state = MOVE

onready var animation_player = $AnimationPlayer 
onready var animation_tree = $AnimationTree
onready var animation_state = animation_tree.get("parameters/playback")
onready var sprite = $Sprite
onready var foot_colider = $FootColider
onready var ray_foot = $FootRaycast

onready var character = character_resource.new()
onready var controller = controller_resource.new(character, self, MOVE, animation_state)
onready var tile_manager = TileManager.new()


func _ready():
	if is_instance_valid(character) : 
		# Start animation
		animation_tree.active = true
		
		# load Sprite texture
		sprite.texture = load(character.get_character_sprite())
		if character.sprite_frames.vframes != 0 :
			sprite.vframes = character.sprite_frames.vframes
		if character.sprite_frames.hframes != 0 :
			sprite.hframes = character.sprite_frames.hframes
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
			var f_pos_y = (sprite.get_rect().size.y / 2) - f_height
			foot_shape.extents = Vector2(7,f_height)
			foot_colider.shape = foot_shape
			foot_colider.position.y += f_pos_y
			
		# Setup Group
		if character.group_name:
			add_to_group(character.group_name)


func _physics_process(delta):
	
	velocity = controller.control(delta, velocity, ray_foot)
	rotate_sprite()
	
	
	velocity = move_and_slide(velocity, Vector2.UP)
	
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
	
func rotate_sprite() -> void:
	sprite.scale.x = controller.rotate_sprite(sprite.scale.x)
	
func _play_sound(effect : String) -> void:
	var sound = null
	$AudioStreamPlayer2D.volume_db = 0
	if effect == "mine" :
		var rnd_snd = RandomNumberGenerator.new()
		rnd_snd.randomize()
		var chance = rnd_snd.randf_range(0, 1) 
		sound = "res://sounds/effects/pickaxe_snd_01.wav"
		
		if chance >= 0.25 and chance < 0.5 :
			sound = "res://sounds/effects/pickaxe_snd_02.wav"
		
		if chance >= 0.5 and chance < 75 :
			sound = "res://sounds/effects/pickaxe_snd_03.wav"
		
		if chance >= 0.75 and chance <= 1 :
			sound = "res://sounds/effects/pickaxe_snd_04.wav"
	
	if effect == "step":
		$AudioStreamPlayer2D.volume_db = -20
		sound = "res://sounds/effects/footstep_01.wav"
	
	if sound :
		$AudioStreamPlayer2D.stream = load(sound)
		$AudioStreamPlayer2D.playing = true
