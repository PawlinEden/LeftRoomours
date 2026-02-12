extends Area2D

@export var inspect_ui: CanvasLayer

func _input_event(viewport, event, shape_idx):
	# ❌ Wenn irgendein Overlay offen ist → nichts tun
	if InspectUI.overlay_open:
		return

	if event is InputEventMouseButton \
	and event.button_index == MOUSE_BUTTON_LEFT \
	and event.pressed:
		if inspect_ui:
			inspect_ui.open("res://graphics/work/bild.png")
