extends "res://characters/npc/npc.gd"



func lick_player() -> void :
	$AnimationPlayer.play("Lick")

func idle_player() -> void :
	$AnimationPlayer.play("Idle")


func _on_Interaction_body_entered(body):
	if body.get_groups().has("player") :
		lick_player()
