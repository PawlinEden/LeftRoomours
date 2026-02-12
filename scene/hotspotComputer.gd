extends Area2D

@export var computer_overlay: CanvasLayer

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton \
	and event.button_index == MOUSE_BUTTON_LEFT \
	and event.pressed:
		if computer_overlay:
			computer_overlay.open()
