extends Area3D

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if not body.is_in_group("player"):
		return

	var camera_rig = body.find_child("CameraRig", true, false)
	if not camera_rig:
		return

	# Lepas dari player
	camera_rig.reparent(get_tree().current_scene, true)

	# MATIKAN FOLLOW
	camera_rig.follow_player = false

	print("CAMERA STOPPED & DETACHED")
	
	
