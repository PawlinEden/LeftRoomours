extends Area2D

@export var inspect_ui: CanvasLayer

# Spezifischer Name für die Platte
@onready var platte_nehm_player: AudioStreamPlayer = $PlatteNehmPlayer

func _input_event(_viewport, event, _shape_idx):
	# ❌ Wenn irgendein Overlay offen ist → nichts tun
	if InspectUI.overlay_open:
		return

	if event is InputEventMouseButton \
	and event.button_index == MOUSE_BUTTON_LEFT \
	and event.pressed:
		
		# 1. Sound: Platte wird genommen
		if platte_nehm_player:
			platte_nehm_player.play()
			
		# 2. UI öffnen
		if inspect_ui:
			inspect_ui.open("res://graphics/work/platte.png")
