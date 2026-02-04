extends Node3D

@export var player: Node3D
@onready var camera: Camera3D = $Camera3D

@export var normal_offset := Vector3(0, 0, 0)
@export var slowmo_offset := Vector3(2, 2, 5)

@export var normal_fov := 60.0
@export var slowmo_fov := 20.0

@export var smooth_speed := 10.0

var slowmo_active := false
var follow_player := true   # 🔥 NEW

func _process(delta: float):
	if player == null:
		return

	var real_delta := delta / Engine.time_scale

	# 🔒 FOLLOW PLAYER HANYA JIKA DIIZINKAN
	if follow_player:
		global_position.x = lerp(
			global_position.x,
			player.global_position.x,
			smooth_speed * real_delta
		)

	var target_offset := slowmo_offset if slowmo_active else normal_offset
	var target_fov := slowmo_fov if slowmo_active else normal_fov

	camera.position = camera.position.lerp(
		target_offset,
		smooth_speed * real_delta
	)

	camera.fov = lerp(
		camera.fov,
		target_fov,
		smooth_speed * real_delta
	)
