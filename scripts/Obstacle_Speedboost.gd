extends "res://scripts/Obstacle_Base.gd"

@export var speed_multiplier := 5.5
@export var boost_duration := 3.0



func on_success():
	var player := get_tree().get_first_node_in_group("player")
	if player:
		player.apply_speed_boost(speed_multiplier, boost_duration)




	clear_obstacle()
