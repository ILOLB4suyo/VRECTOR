extends Label3D

@export var target_phrase := "BUKA JALAN"
@export var time_limit := 4.0

@onready var music: AudioStreamPlayer = $AudioStreamPlayer
@onready var achieve_sfx: AudioStreamPlayer = $AchieveSFX

var already_finished := false
var typed_text := ""
var is_typing := false
var prompt_text := ""
var timeout_timer: Timer
var time_left := 0.0

signal typing_finished(success: bool)

func _ready():
	prompt_text = 'ketik:\n"' + target_phrase + '"\n'
	text = prompt_text
	
	# Setup timer
	timeout_timer = Timer.new()
	timeout_timer.one_shot = true
	timeout_timer.wait_time = time_limit
	timeout_timer.ignore_time_scale = true 
	timeout_timer.timeout.connect(_on_timeout)
	add_child(timeout_timer)

func start_typing():
	enter_typing_mode()
	time_left = time_limit
	timeout_timer.start()
	
	if music and not music.playing:
		music.play()

func enter_typing_mode():
	is_typing = true
	already_finished = false
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
	if not is_typing or already_finished:
		return
	
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_ESCAPE:
			exit_typing_mode()
			return
		
		if event.keycode == KEY_BACKSPACE:
			if typed_text.length() > 0:
				typed_text = typed_text.substr(0, typed_text.length() - 1)
		elif event.unicode > 0:
			typed_text += char(event.unicode)
		
		text = prompt_text + typed_text
		
		# CEK: Apakah typing benar?
		if typed_text == target_phrase:
			already_finished = true
			
			print("TYPING BENAR:", typed_text)
			
			text = "BERHASIL!"
			modulate = Color.GREEN
			
			# PLAY SFX via Global (tidak terpengaruh slowmo atau node dihapus)
			if achieve_sfx and achieve_sfx.stream:
				GlobalSFX.play_achieve(achieve_sfx.stream)
			
			# Emit signal + exit typing mode
			typing_finished.emit(true)
			exit_typing_mode()
func _on_timeout():
	if not is_typing:
		return
	
	print("TIMEOUT!")
	text = "WAKTU HABIS!"
	modulate = Color.RED
	
	typing_finished.emit(false)
	exit_typing_mode()

func _process(delta: float) -> void:
	if not is_typing:
		return
	
	var real_delta: float = delta / float(Engine.time_scale)
	time_left -= real_delta
	time_left = max(time_left, 0.0)
	
	text = prompt_text + typed_text + "\n" + "%.2f" % time_left
	
	var ratio: float = time_left / time_limit
	if ratio < 0.3:
		modulate = Color.RED
	elif ratio < 0.6:
		modulate = Color.YELLOW
	else:
		modulate = Color.WHITE
