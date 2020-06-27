extends KinematicBody2D

enum {
	MOVE, DIG
}

export (Resource) var character_resource
export (Resource) var controller

onready var animation_player = $AnimationPlayer 
onready var animation_tree = $AnimationTree
onready var animation_state = animation_tree.get("parameters/playback")
onready var sprite = $Sprite
onready var foot_colider = $FootColider

onready var default_character = character_resource.new()
onready var default_controller = controller.new(default_character, MOVE, animation_state)

var velocity = Vector2.ZERO
var state = MOVE


func _ready():
	if is_instance_valid(default_character) : 
		
		# Start animation
		animation_tree.active = true
		
		# load Sprite texture
		sprite.texture = load(default_character.get_character_sprite())

		# Setup camera (If exists)
		if default_character.get_active_camera() : 
			var scene_camera = Camera2D.new()
			scene_camera.current = default_character.get_active_camera()
			scene_camera.zoom = default_character.camera_zoom
			self.add_child(scene_camera)

		# Configure the collison objects for the character
		if not is_instance_valid(default_character.get_foot_collider_shape()):
			var foot_shape = RectangleShape2D.new()
			var f_height = sprite.get_rect().size.y / 8
			var f_pos_y = (sprite.get_rect().size.y/2) - f_height
			foot_shape.extents = Vector2(7,f_height)
			foot_colider.shape = foot_shape
			foot_colider.position.y += f_pos_y
			

func _physics_process(delta):
	velocity = default_controller.control(delta, velocity)
	rotate_sprite()
	
	velocity = move_and_slide(velocity)
	
func return_to_move_state() -> void :
	default_controller.return_to_move_state()
	
func rotate_sprite() -> void:
	sprite.scale.x = default_controller.rotate_sprite()
