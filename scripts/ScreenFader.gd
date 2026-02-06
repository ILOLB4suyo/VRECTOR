extends CanvasLayer

@onready var rect: ColorRect = $ColorRect
var fade_time := 1.5

func fade_out():
	print("FADE OUT START")
	
	GameState.is_fading = true
	rect.visible = true
	var c := rect.color
	c.a = 0.0
	rect.color = c
	
	

	var tween := create_tween()
	tween.tween_property(
		rect,
		"color:a",
		1.0,
		fade_time
	)
	await tween.finished

	print("FADE OUT DONE")


func fade_in():
	print("FADE IN START")

	rect.visible = true
	var c := rect.color
	c.a = 1.0
	rect.color = c

	var tween := create_tween()
	tween.tween_property(
		rect,
		"color:a",
		0.0,
		fade_time
	)
	await tween.finished

	rect.visible = false
	
	GameState.is_fading = false
	
	print("FADE IN DONE")
