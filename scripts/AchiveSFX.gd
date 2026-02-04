extends Node

@onready var player := AudioStreamPlayer.new()

func _ready():
	add_child(player)
	player.stream = preload("res://Assets/Music/sfx/achieve_goal.ogg")

func play():
	player.play()
