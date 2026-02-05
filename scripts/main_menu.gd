extends Control

@onready var input_label: Label = $CenterContainer/VBoxContainer/Column
@onready var instruction_label: Label = $CenterContainer/VBoxContainer/Perintah
@onready var achieve_sfx: AudioStreamPlayer = $AchieveSFX

const TARGET_WORD := "START"
var typed_text := ""

func _ready():
	# Set initial text
	input_label.text = ""
	
	# Capture keyboard input
	set_process_input(true)

func _input(event):
	if event is InputEventKey and event.pressed and not event.echo:
		# Handle backspace
		if event.keycode == KEY_BACKSPACE:
			if typed_text.length() > 0:
				typed_text = typed_text.substr(0, typed_text.length() - 1)
				update_display()
		
		# Handle escape (clear)
		elif event.keycode == KEY_ESCAPE:
			typed_text = ""
			update_display()
		
		# Handle character input
		elif event.unicode > 0:
			var char_typed = char(event.unicode).to_upper()
			typed_text += char_typed
			update_display()
			
			# Check if correct
			if typed_text == TARGET_WORD:
				on_correct_input()

func update_display():
	input_label.text = typed_text
	
	# Visual feedback - warna berubah sesuai progress
	if typed_text.length() == 0:
		input_label.modulate = Color.BLACK
	else:
		# Salah - merah
		input_label.modulate = Color.RED

func on_correct_input():
	print("✓ Correct! Starting game...")
	
	# Visual feedback
	input_label.text =  typed_text 
	input_label.modulate = Color.BLUE
	
	# Play SFX
	if achieve_sfx:
		achieve_sfx.play()
	
	# Wait a bit then start game
	await get_tree().create_timer(0.5).timeout
	
	# Change to game scene
	get_tree().change_scene_to_file("res://main.tscn")
