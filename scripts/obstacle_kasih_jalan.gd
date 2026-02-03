extends Node3D

@onready var obstacle_body := $StaticBody3D
@onready var obstacle_hitbox := $ObstacleHitbox
@onready var slowmo_area := $SlowmoArea
@onready var typing_prompt := $TypingPrompt
@onready var platform := $Platform
@onready var platform_target := $PlatformTarget

@export var platform_speed := 13.0




var cleared := false
var platform_moving := false

func _ready():
	obstacle_hitbox.body_entered.connect(_on_player_hit)
	typing_prompt.typing_finished.connect(_on_typing_finished)


func _on_typing_finished(success: bool):
	if success:
		print("SUCCESS → platform naik")
		start_platform()
	else:
		print("FAIL → tidak ada platform")


func start_platform():
	if platform_moving:
		return

	platform_moving = true
	cleared = true

	# rintangan utama hilang (opsional)
	obstacle_body.queue_free()
	obstacle_hitbox.queue_free()
	slowmo_area.queue_free()


func _physics_process(delta):
	if not platform_moving:
		return

	platform.global_position = platform.global_position.move_toward(
		platform_target.global_position,
		platform_speed * delta
	)

	if platform.global_position.distance_to(platform_target.global_position) < 0.05:
		platform_moving = false


func _on_player_hit(body):
	if cleared:
		return

	#if body.is_in_group("player"):
		#print("FAIL → player mati")
		#get_tree().reload_current_scene()
		#
