#extends Node3D
#
#@onready var obstacle_body := $StaticBody3D
#@onready var obstacle_hitbox := $ObstacleHitbox
#@onready var slowmo_area := $SlowmoArea
#@onready var typing_prompt := $TypingPrompt
#@onready var fail_sfx: AudioStreamPlayer = $FailSFX
#
#var cleared := false
#var game_over_triggered := false
#
#func _ready():
	#obstacle_hitbox.body_entered.connect(_on_player_hit)
	#typing_prompt.typing_finished.connect(_on_typing_finished)
#
#func _on_typing_finished(success: bool):
	#if success:
		#clear_obstacle()
#
#func clear_obstacle():
	#cleared = true
	#obstacle_body.queue_free()
	#obstacle_hitbox.queue_free()
	#slowmo_area.queue_free()
	#typing_prompt.queue_free()
#
#func _on_player_hit(body):
	#if cleared or game_over_triggered:
		#return
#
	#if body.is_in_group("player"):
		#game_over_triggered = true
		#handle_game_over(body)
#
#func handle_game_over(player):
	#print("FAIL → player mati")
#
	#Engine.time_scale = 1.0
#
	## matikan kontrol player
	#player.can_move = false
#
	## play sfx fail
	#if fail_sfx:
		#fail_sfx.play()
		#await fail_sfx.finished
#
	#get_tree().reload_current_scene()
	#
	#
	#


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
	clear_obstacle()

func on_fail():
	pass # default: nabrak = mati

func clear_obstacle():
	cleared = true
	obstacle_body.queue_free()
	obstacle_hitbox.queue_free()
	slowmo_area.queue_free()
	typing_prompt.queue_free()

func _on_player_hit(body):
	if cleared or game_over_triggered:
		return
	if body.is_in_group("player"):
		game_over_triggered = true
		handle_game_over(body)

func handle_game_over(player):
	Engine.time_scale = 1.0
	player.can_move = false

	if fail_sfx:
		fail_sfx.play()
		await fail_sfx.finished

	get_tree().reload_current_scene()


func _exit_tree():
	if typing_prompt and typing_prompt.typing_finished.is_connected(_on_typing_finished):
		typing_prompt.typing_finished.disconnect(_on_typing_finished)
