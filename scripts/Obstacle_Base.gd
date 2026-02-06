extends Node3D

@onready var obstacle_body := $StaticBody3D
@onready var obstacle_hitbox := $ObstacleHitbox
@onready var slowmo_area := $SlowmoArea
@onready var typing_prompt := $TypingPrompt
@onready var fail_sfx := $FailSFX

var cleared := false
var game_over_triggered := false

func _ready():
	obstacle_hitbox.body_entered.connect(_on_player_hit)
	typing_prompt.typing_finished.connect(_on_typing_finished)

func _on_typing_finished(success: bool):
	if success:
		on_success()
	else:
		on_fail()

func on_success():
	print("✓ Typing berhasil → Obstacle akan dihapus")
	# HANYA clear obstacle (TIDAK ada jump/action apapun)
	clear_obstacle()

func on_fail():
	print("✗ Typing gagal → Obstacle tetap ada")
	# Obstacle tetap ada, player akan mati kalau nabrak

func clear_obstacle():
	cleared = true
	
	# Hapus semua komponen obstacle
	obstacle_body.queue_free()
	obstacle_hitbox.queue_free()
	slowmo_area.queue_free()
	typing_prompt.queue_free()
	
	print("→ Obstacle sudah dihapus")

func _on_player_hit(body):
	if cleared or game_over_triggered:
		return
	
	if body.is_in_group("player"):
		game_over_triggered = true
		handle_game_over(body)

func handle_game_over(player):
	print("💀 GAME OVER - Player kena obstacle")
	
	Engine.time_scale = 1.0
	
	if player.has_method("die"):
		player.die()
	
	if fail_sfx:
		fail_sfx.play()
	
	await get_tree().create_timer(0.7).timeout
	get_tree().reload_current_scene()
