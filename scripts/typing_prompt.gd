extends Label3D

@export var target_phrase := "BUKA JALAN"
@export var time_limit := 4.0

@onready var music: AudioStreamPlayer = $AudioStreamPlayer


var typed_text := ""
var is_typing := false
var prompt_text := ""



var timeout_timer: Timer

var time_left := 0.0



signal typing_finished(success: bool)
signal typing_failed

func _ready():
	prompt_text = 'ketik:\n"' + target_phrase + '"\n'
	text = prompt_text
	
	#timer
	timeout_timer = Timer.new()
	timeout_timer.one_shot = true
	timeout_timer.wait_time = time_limit
	timeout_timer.ignore_time_scale = true 
	timeout_timer.timeout.connect(_on_timeout)
	add_child(timeout_timer)



func _on_area_3d_input_event(camera, event, position, normal, shape_idx):
	if event is InputEventMouseButton \
	and event.pressed \
	and event.button_index == MOUSE_BUTTON_LEFT:
		enter_typing_mode()


func start_typing():
	enter_typing_mode()
	time_left = time_limit
	timeout_timer.start()
	
	if music and not music.playing:
		music.play()



func enter_typing_mode():
	is_typing = true
	typed_text = ""
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	text = prompt_text

	var player := get_tree().get_first_node_in_group("player")
	if player:
		player.can_move = false

func exit_typing_mode():
	is_typing = false
	timeout_timer.stop()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	modulate = Color.WHITE
	
	if music and music.playing:
		music.stop()


	var player := get_tree().get_first_node_in_group("player")
	if player:
		player.can_move = true
	


func _input(event):
	if not is_typing:
		return

	if event is InputEventKey and event.pressed and not event.echo:

		if event.keycode == KEY_ESCAPE:
			exit_typing_mode()
			return

		if event.keycode == KEY_ENTER:
			print("Typed:", typed_text)

			var success := typed_text == target_phrase
			typing_finished.emit(success)

			if success:
				var player := get_tree().get_first_node_in_group("player")
				if player:
					player.force_jump()

			exit_typing_mode()
			return

		if event.keycode == KEY_BACKSPACE:
			if typed_text.length() > 0:
				typed_text = typed_text.substr(0, typed_text.length() - 1)

		elif event.unicode > 0:
			typed_text += char(event.unicode)

		text = prompt_text + typed_text


func _on_timeout():
	if not is_typing:
		return

	print("TIMEOUT!")
	typing_finished.emit(false)
	exit_typing_mode()


func _process(delta: float) -> void:
	if not is_typing:
		return

	var real_delta: float = delta / float(Engine.time_scale)

	time_left -= real_delta
	time_left = max(time_left, 0.0)

	text = prompt_text + typed_text + "\n⏱ " + "%.2f" % time_left

	var ratio: float = time_left / time_limit
	if ratio < 0.3:
		modulate = Color.RED
	elif ratio < 0.6:
		modulate = Color.YELLOW
	else:
		modulate = Color.WHITE





func on_correct_phrase():
	text = "✓ BERHASIL!"
	modulate = Color.GREEN
	print("BENAR:", typed_text)
	#spawn_floor()
	
	reset_prompt()


func on_wrong_phrase():
	text = "✗ SALAH!"
	modulate = Color.RED
	print("SALAH:", typed_text)
	
	reset_prompt()




func spawn_floor():
	var floor := StaticBody3D.new()

	var collision := CollisionShape3D.new()
	var shape := BoxShape3D.new()
	shape.size = Vector3(4, 0.5, 4)
	collision.shape = shape
	floor.add_child(collision)

	var mesh := MeshInstance3D.new()
	var box := BoxMesh.new()
	box.size = shape.size
	mesh.mesh = box
	floor.add_child(mesh)

	# spawn di depan player
	var player := get_tree().get_first_node_in_group("player")
	if player:
		floor.global_position = player.global_position + Vector3(0, -1, -4)

	get_tree().current_scene.add_child(floor)



func reset_prompt():
	await get_tree().create_timer(1.5).timeout
	modulate = Color.WHITE
	text = prompt_text
	typed_text = ""
	
