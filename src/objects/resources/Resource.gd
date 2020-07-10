extends RigidBody2D

signal item_picked

export (String, "wood", "rock", "water") var config_material
export (String, FILE) var default_sprite

var game_material
var resource_owner

onready var game_materials = GameMaterials.new()
onready var level = get_tree().get_root().get_node("Game/Level")

func _ready():
	
	if config_material != null :
		setup_object(config_material)
		# Conecta sinal de corte de árvore
		connect("item_picked", level, "add_item_to_inventory")
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
	var shape = CapsuleShape2D.new()
	shape.radius = $Sprite.get_rect().size.x /2.5
	shape.height = $Sprite.get_rect().size.x / 2
	$CollisionShape2D.shape = shape
	$CollisionShape2D.rotation_degrees = 90
	
	resource_lifetime(game_material)


func resource_lifetime(game_material_local):
	game_material = game_material_local
	var lf_tm = 20
	if game_material.has("lifetime") :
		lf_tm = game_material.lifetime
	var t = Timer.new()
	t.set_wait_time(lf_tm)
	t.set_one_shot(true)
	add_child(t)
	t.start()
	yield(t, "timeout")
	linear_velocity.y += -50
	t.queue_free()
	play_puff()
	

func play_puff() -> void:
	$AnimationPlayer.play("Puff")

func destroy() -> void:
	queue_free()

func set_resource_owner (body) :
	resource_owner = body
	emit_signal("item_picked",body, self)

func _on_PickArea_body_entered(body):
	if not resource_owner and body.get_groups().has("player"): 
		set_resource_owner(body)
