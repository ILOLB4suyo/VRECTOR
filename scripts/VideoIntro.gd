extends CanvasLayer

@onready var video: VideoStreamPlayer = $VideoStreamPlayer

func _ready():
	print("VIDEO INTRO READY")

	# 🔑 WAJIB: tetap proses walau game pause
	process_mode = Node.PROCESS_MODE_ALWAYS
	video.process_mode = Node.PROCESS_MODE_ALWAYS

	video.visible = true
	video.play()

	# pause game setelah video mulai
	get_tree().paused = true

	video.finished.connect(_on_video_finished)

func _on_video_finished():
	print("VIDEO SELESAI")

	get_tree().paused = false
	video.stop()
	queue_free()
