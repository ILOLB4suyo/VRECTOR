extends Area3D

@export var slowmo_scale := 0.05
@export var typing_prompt: Label3D

var slowmo_active := false

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if not body.is_in_group("player"):
		return
	
	if slowmo_active:
		return
	
	slowmo_active = true
	Engine.time_scale = slowmo_scale
	
	# Aktifkan efek kamera slowmo (kalau ada)
	var camera_rig = body.get_node_or_null("CameraRig")
	if camera_rig:
		camera_rig.slowmo_active = true
	
	# Mulai typing
	if typing_prompt:
		typing_prompt.start_typing()
		typing_prompt.typing_finished.connect(_on_typing_finished)

func _on_typing_finished(success: bool):
	# Kembalikan waktu ke normal
	Engine.time_scale = 1.0
	slowmo_active = false
	
	# Matikan efek kamera slowmo
	var player := get_tree().get_first_node_in_group("player")
	if player:
		var camera_rig := player.get_node_or_null("CameraRig")
		if camera_rig:
			camera_rig.slowmo_active = false
	
	# CABUT SEMUA KODE JUMP!
	# Sekarang HANYA handle slowmo, obstacle yang handle success/fail
	
	# Putuskan signal
	if typing_prompt and typing_prompt.typing_finished.is_connected(_on_typing_finished):
		typing_prompt.typing_finished.disconnect(_on_typing_finished)
