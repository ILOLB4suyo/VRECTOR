extends Node3D

@onready var obstacle_body := $StaticBody3D
@onready var obstacle_hitbox := $ObstacleHitbox
@onready var slowmo_area := $SlowmoArea
@onready var typing_prompt := $TypingPrompt
@onready var platform := $Platform1
@onready var platform_target := $PlatformTarget13

@export var platform_speed := 13.0

var cleared := false
var platform_moving := false

func _ready():
	obstacle_hitbox.body_entered.connect(_on_player_hit)
	typing_prompt.typing_finished.connect(_on_typing_finished)

func _on_typing_finished(success: bool):
	if success:
		print("✓ Typing berhasil → Platform akan muncul")
		start_platform()
	else:
		print("✗ Typing gagal → Tidak ada platform")

func start_platform():
	if platform_moving:
		return
	
	platform_moving = true
	cleared = true
	
	# Rintangan utama hilang
	obstacle_body.queue_free()
	obstacle_hitbox.queue_free()
	slowmo_area.queue_free()
	# typing_prompt dibiarkan biar player tau sudah berhasil

func _physics_process(delta):
	if not platform_moving:
		return
	
	platform.global_position = platform.global_position.move_toward(
		platform_target.global_position,
		platform_speed * delta
	)
	
	if platform.global_position.distance_to(platform_target.global_position) < 0.05:
		platform_moving = false
		print("→ Platform sudah sampai posisi")

func _on_player_hit(body):
	if cleared:
		return
	# Kalau mau tambah game over bisa di sini
