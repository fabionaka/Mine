extends Node
class_name Character 
var sprite_texture = "res://assets/characters/base-char.png" setget set_character_sprite, get_character_sprite
var active_camera : bool setget set_active_camera, get_active_camera
var camera_zoom : Vector2 = Vector2(1,1)
var foot_collider_shape setget set_foot_collider_shape, get_foot_collider_shape
var sprite_frames = {"vframes" : 0, "hframes":0}
var group_name : String

# fisica
var max_speed : int = 100
var max_acceleration : int = 500
var friction : int = 500
var health : int = 0

func _init():
	active_camera = false


func set_character_sprite(value):
	sprite_texture = value
func get_character_sprite():
	return sprite_texture
	
func set_active_camera(value):
	active_camera = value
func get_active_camera():
	return active_camera

func set_foot_collider_shape(value):
	foot_collider_shape = value
func get_foot_collider_shape():
	return foot_collider_shape
