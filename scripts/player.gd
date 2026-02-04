extends CharacterBody3D

@export var run_speed: float = 10.0
@export var gravity: float = 20.0
@export var jump_velocity: float = 10.0

@onready var jump_sfx: AudioStreamPlayer = $JumpSFX


var can_move := true

func force_jump():
	velocity.y = jump_velocity

func force_jump_extra(multiplier: float = 1.5):
	velocity.y = jump_velocity * multiplier

	if jump_sfx:
		jump_sfx.play()


func do_jump():
	if is_on_floor():
		velocity.y = jump_velocity

		if jump_sfx:
			jump_sfx.play()




func _physics_process(delta: float) -> void:
	# Auto-run ke kanan (sumbu X)
	velocity.x = run_speed
	velocity.z = 0.0

	# Gravity
	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		if velocity.y < 0.0:
			velocity.y = 0.0

	# Jump
	#if Input.is_action_just_pressed("jump") and is_on_floor():
		#velocity.y = jump_velocity
	
	

	move_and_slide()

func apply_speed_boost(multiplier: float, duration: float):
	run_speed *= multiplier

	await get_tree().create_timer(duration).timeout

	run_speed /= multiplier
