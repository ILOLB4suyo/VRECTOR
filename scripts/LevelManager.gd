extends Node

var levels := [
	"res://main.tscn",                 
	"res://Levels/Level_2.tscn",
	"res://Levels/Level_3.tscn",
	"res://Levels/Level_4.tscn",
	"res://Levels/Level_5.tscn",
	"res://scene/Main_menu.tscn"       
]

var current_level := 0

func _ready():
	LevelManager.detect_current_level()

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
	if current_level + 1 >= levels.size():
		print("SEMUA LEVEL SELESAI → KEMBALI KE MENU")
	load_level(current_level + 1)


func detect_current_level():
	var current_scene_path := get_tree().current_scene.scene_file_path

	for i in range(levels.size()):
		if levels[i] == current_scene_path:
			current_level = i
			print("DETECT LEVEL:", current_level, current_scene_path)
			return

	print("WARNING: Scene tidak terdaftar di LevelManager")
