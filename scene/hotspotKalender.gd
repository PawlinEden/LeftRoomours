extends Area2D

@export var inspect_ui: CanvasLayer

# Der AudioPlayer als Kind-Node vom Hotspot
@onready var kalender_auf_player: AudioStreamPlayer = $KalenderAufPlayer

func _input_event(_viewport, event, _shape_idx):
	# Zugriff auf InspectUI (Global oder Variable prüfen)
	if InspectUI.overlay_open:
		return   # ❌ Overlay offen → Hotspot ignorieren

	if event is InputEventMouseButton \
	and event.button_index == MOUSE_BUTTON_LEFT \
	and event.pressed:
		
		# 1. Sound abspielen
		if kalender_auf_player:
			kalender_auf_player.play()
		
		# 2. UI öffnen
		if inspect_ui:
			inspect_ui.open("res://graphics/work/calender.png")
