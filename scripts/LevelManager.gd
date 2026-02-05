extends Node

var levels := [
	"res://main.tcsn",
	"res://Levels/Level_2.tscn",
	"res://Levels/Level_3.tscn",
	"res://Levels/Level_4.tscn",
	"res://Levels/Level_5.tscn"
]

var current_level := 0

func load_level(index: int):
	if index < 0 or index >= levels.size():
		print("GAME TAMAT 🎉")
		return
	
	await ScreenFader.fade_out()
	
	current_level = index
	get_tree().change_scene_to_file(levels[index])
	
	await get_tree().process_frame
	await ScreenFader.fade_in()

func next_level():
	load_level(current_level + 1)
	
