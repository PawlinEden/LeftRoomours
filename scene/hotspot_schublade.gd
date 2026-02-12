extends Area2D

@export var inspect_ui: CanvasLayer

# Spezifischer Name für das Öffnen der Schublade
@onready var schublade_auf_player: AudioStreamPlayer = $SchubladeAufPlayer

func _input_event(_viewport, event, _shape_idx):
	# ❌ Wenn irgendein Overlay offen ist → nichts tun
	if InspectUI.overlay_open:
		return

	if event is InputEventMouseButton \
	and event.button_index == MOUSE_BUTTON_LEFT \
	and event.pressed:
		
		# 1. Sound: Schublade geht auf
		if schublade_auf_player:
			schublade_auf_player.play()
			
		# 2. UI/Inhalt öffnen
		if inspect_ui:
			inspect_ui.open("res://graphics/work/schublade.png")
