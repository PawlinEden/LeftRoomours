extends Area2D

@export var inspect_ui: CanvasLayer

# 🔊 Der Sound-Player für das Aufheben des Bildes
@onready var zettel_nehm_player: AudioStreamPlayer = $ZettelNehmPlayer

func _input_event(_viewport, event, _shape_idx):
	# ❌ Wenn irgendein Overlay offen ist → nichts tun
	if InspectUI.overlay_open:
		return

	if event is InputEventMouseButton \
	and event.button_index == MOUSE_BUTTON_LEFT \
	and event.pressed:
		
		# 1. Sound abspielen: "Zettel/Bild aufheben"
		if zettel_nehm_player:
			zettel_nehm_player.play()
		
		# 2. Das Bild-Overlay öffnen
		if inspect_ui:
			inspect_ui.open("res://graphics/work/bild.png")
