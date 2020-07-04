extends Area2D

export (int) var spook_radius = 50

onready var collision = $CollisionShape2D

func _ready():
	collision.shape.radius = spook_radius
