extends Node3D

@export var roll_speed := 8.0
@export var roll_direction := 1      # 1 = kanan, -1 = kiri
@export var spin_multiplier := 1.5

@onready var barrel: RigidBody3D = $Spine
@onready var kill_area: Area3D = $Spine/KillArea
@onready var start_area: Area3D = $StartArea
@onready var fail_sfx := $FailSFX

var active := false   # 🔒 BELUM JALAN

func _ready():
	# Barrel awalnya diam
	barrel.freeze = true

	kill_area.body_entered.connect(_on_kill_area_entered)
	start_area.body_entered.connect(_on_start_area_entered)


func _physics_process(delta):
	if not active:
		return

	barrel.linear_velocity.x = roll_speed * roll_direction
	barrel.angular_velocity.z = -roll_speed * spin_multiplier * roll_direction


func _on_start_area_entered(body):
	if not body.is_in_group("player"):
		return

	print("BARREL AKTIF 🔥")
	active = true
	barrel.freeze = false

	# optional: supaya cuma aktif sekali
	start_area.queue_free()


func _on_kill_area_entered(body):
	if body.is_in_group("player"):
		kill_player(body)


func kill_player(player):
	Engine.time_scale = 1.0
	player.can_move = false

	if fail_sfx:
		fail_sfx.play()
		await fail_sfx.finished

	get_tree().reload_current_scene()
