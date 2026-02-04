extends "res://Scripts/Obstacle_Base.gd"


@export var climb_height := 8
@export var climb_duration := 2

func on_success():
	var player := get_tree().get_first_node_in_group("player")
	if player and player.has_method("do_climb"):
		player.do_climb(climb_height, climb_duration)
	
	clear_obstacle()
