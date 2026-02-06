extends CharacterBody3D

@export var run_speed: float = 10.0
@export var gravity: float = 20.0
@export var jump_velocity: float = 10.0

@onready var jump_sfx: AudioStreamPlayer = $JumpSFX
@onready var animation_player: AnimationPlayer = $AnimationPlayer


var can_move := true
var is_climbing := false

func force_jump():
	velocity.y = jump_velocity
	play_jump()

func force_jump_extra(multiplier: float = 2.5):
	velocity.y = jump_velocity * multiplier

	if jump_sfx:
		jump_sfx.play()
	play_jump()


func do_jump():
	if can_move and is_on_floor():
		velocity.y = jump_velocity
		if jump_sfx:
			jump_sfx.play()
		play_jump()

func do_climb(target_height: float, duration: float = 2.5):
	if is_climbing:
		return
	
	is_climbing = true
	can_move = false
	play_climb()
	
	
	var start_y = global_position.y
	var target_y = start_y + target_height
	var elapsed = 0.0
	
	# Animasi naik smooth
	while elapsed < duration:
		elapsed += get_process_delta_time()
		var progress = elapsed / duration
		
		# Easing untuk gerakan smooth
		var eased = ease(progress, -2.0)
		
		global_position.y = lerp(start_y, target_y, eased)
		
		await get_tree().process_frame
	
	# Pastikan sampai posisi akhir
	global_position.y = target_y
	
	is_climbing = false
	can_move = true
	play_run()


func _physics_process(delta: float) -> void:
	if is_climbing:
		return

	velocity.x = run_speed
	velocity.z = 0.0

	if not is_on_floor():
		velocity.y -= gravity * delta
		# animasi jatuh
		if velocity.y < 0 and animation_player.current_animation != "fall":
			play_fall()
	else:
		if velocity.y < 0.0:
			velocity.y = 0.0
		# animasi lari
		if animation_player.current_animation != "run":
			play_run()

	move_and_slide()

	

func apply_speed_boost(multiplier: float, duration: float):
	run_speed *= multiplier

	await get_tree().create_timer(duration).timeout

	run_speed /= multiplier

func play_run():
	if animation_player.current_animation != "run":
		animation_player.play("run")

func play_jump():
	if animation_player.current_animation != "jump":
		animation_player.play("jump")

func play_fall():
	if animation_player.current_animation != "fall":
		animation_player.play("fall")

func play_climb():
	if animation_player.current_animation != "climb":
		animation_player.play("climb")
func die():
	can_move = false
	velocity = Vector3.ZERO
	play_fall()
	
	# Hilangkan visual + collision
	hide()
	set_physics_process(false)
	set_process(false)
