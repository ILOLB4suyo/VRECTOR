extends Node

var achieve_player: AudioStreamPlayer

func _ready():
	# Buat AudioStreamPlayer global
	achieve_player = AudioStreamPlayer.new()
	achieve_player.bus = "Master"
	add_child(achieve_player)

func play_achieve(stream: AudioStream):
	if achieve_player and stream:
		achieve_player.stream = stream
		achieve_player.play()
		print("Global SFX achieve dimainkan!")
