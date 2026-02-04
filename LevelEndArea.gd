extends Area3D

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if not body.is_in_group("player"):
		return

	print("LEVEL SELESAI")

	await get_tree().create_timer(0.5).timeout
	LevelManager.next_level()
