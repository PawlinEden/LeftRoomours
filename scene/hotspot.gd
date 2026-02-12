extends Area2D

# Referenz zum Overlay/InspectUI
@export var inspect_ui: CanvasLayer

# Name des Hotspots, wird im Inspector pro Node gesetzt
@export var hotspot_name: String = "hotspotKalender"

# Dictionary mit allen Bildern
var hotspot_images = {
	"hotspotKalender": "res://graphics/work/calender.png",
	"hotspotComputer": "res://graphics/work/computer.png",
	"hotspotTür": "res://graphics/work/tuer.png"
}

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		_show_hotspot_image()

# Zeigt das Bild für den jeweiligen Hotspot
func _show_hotspot_image():
	if inspect_ui and hotspot_images.has(hotspot_name):
		var path = hotspot_images[hotspot_name]
		inspect_ui.open(path)
	else:
		print("Fehler: Hotspot oder Bildpfad nicht gefunden für ", hotspot_name)
