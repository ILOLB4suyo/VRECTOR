extends "res://Scripts/Obstacle_Base.gd"

func on_success():
	var player := get_tree().get_first_node_in_group("player")
	if player and player.has_method("force_jump"):
		player.force_jump()

	clear_obstacle()
