class_name InspectUI
extends CanvasLayer

@onready var image = $TextureRect
@onready var close_button = $CloseButton

# Der Player für den Schließen-Sound (muss in der Szene existieren)
@onready var zettel_weg_player: AudioStreamPlayer = $ZettelWegPlayer

# 🔒 GLOBALER STATUS (für alle Overlays)
static var overlay_open: bool = false

func _ready():
	hide()
	close_button.hide()
	close_button.pressed.connect(close)

func open(texture_path: String):
	# ❌ Wenn schon ein Overlay offen ist → nichts tun
	if overlay_open:
		return

	var tex = load(texture_path)
	if tex:
		image.texture = tex
		show()
		close_button.show()
		overlay_open = true   # 🔒 blockiert alle anderen Hotspots

func close():
	# 🔊 Sound abspielen, bevor das UI verschwindet
	if zettel_weg_player:
		zettel_weg_player.play()
	
	hide()
	close_button.hide()
	overlay_open = false     # 🔓 Hotspots wieder freigeben

func _input(event):
	# Schließen per ESC-Taste (ui_cancel) spielt jetzt auch den Sound ab
	if visible and event.is_action_pressed("ui_cancel"):
		close()
