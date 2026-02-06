extends CanvasLayer

var is_paused := false

func _ready():
	visible = false
	process_mode = Node.PROCESS_MODE_ALWAYS

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		
		if GameState.is_typing_active:
			print("PAUSE DIBLOK: SEDANG TYPING")
			return
		
		if GameState.is_fading:
			print("PAUSE DIBLOK: SEDANG TRANSISI")
			return
		
		if GameState.is_slowmo:
			print("PAUSE DIBLOK: SEDANG SLOWMO")
			return
		
		if is_paused:
			hide_pause()
		else:
			show_pause()


func show_pause():
	is_paused = true
	visible = true
	get_tree().paused = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func hide_pause():
	is_paused = false
	visible = false
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
