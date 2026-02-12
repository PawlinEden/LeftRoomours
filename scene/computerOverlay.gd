extends CanvasLayer

@export var hotspots_root: Node

@onready var image1: TextureRect = $Image1
@onready var image2: TextureRect = $Image2
@onready var image3: TextureRect = $Image3

@onready var password_layer: Control = $PasswordLayer
@onready var password_input: LineEdit = $PasswordLayer/LineEdit
@onready var password_close: Area2D = $PasswordLayer/CloseArea
@onready var submit_button: Button = $PasswordLayer/SubmitButton

# Audio Player
@onready var computer_sound_player: AudioStreamPlayer = $ComputerSoundPlayer
@onready var computer_off_player: AudioStreamPlayer = $ComputerOffPlayer
@onready var computer_bing_player: AudioStreamPlayer = $ComputerBingPlayer
@onready var computer_klick_player: AudioStreamPlayer = $ComputerKlickPlayer

const CORRECT_PASSWORD := "161"

func _ready():
	hide()
	password_layer.hide()
	
	if submit_button:
		submit_button.hide()
		submit_button.flat = true 
		if not submit_button.pressed.is_connected(_on_submit_pressed):
			submit_button.pressed.connect(_on_submit_pressed)
	
	# Layer lässt Klicks durch, damit man Bilder dahinter erreicht
	password_layer.mouse_filter = Control.MOUSE_FILTER_PASS
	password_input.text_submitted.connect(_on_password_entered)
	
	# Alle CloseAreas der Bilder verbinden
	$Image1/CloseArea.input_event.connect(_on_image_close.bind(image1))
	$Image2/CloseArea.input_event.connect(_on_image_close.bind(image2))
	$Image3/CloseArea.input_event.connect(_on_image_close.bind(image3))
	
	# Passwort-Fenster Schließen (X-Button oder Area)
	if password_close:
		password_close.input_event.connect(_on_password_close)

func open():
	_set_hotspots_disabled(true)
	if computer_sound_player: computer_sound_player.play()
	
	# Texturen laden
	image1.texture = load("res://graphics/work/computer_1.png")
	image2.texture = load("res://graphics/work/computer_2.png")
	image3.texture = load("res://graphics/work/computer_3.png")
	
	# Alles sofort anzeigen
	image1.show()
	image2.show()
	image3.show()
	password_layer.show()
	if submit_button: submit_button.show()
	
	# Passwort sofort aktiv schalten (nicht mehr auf Bild 2 warten)
	password_input.text = ""
	password_input.editable = true 
	
	# Stapelreihenfolge (Z-Index)
	# So liegen sie übereinander, können aber einzeln weggeklickt werden
	image1.z_index = 10
	image2.z_index = 9
	password_layer.z_index = 8
	image3.z_index = 1
	
	show()

func _on_submit_pressed():
	if computer_klick_player: computer_klick_player.play()
	_on_password_entered(password_input.text)

func _on_password_entered(text: String):
	# Wir prüfen nur, wenn das Passwort-Feld auch wirklich sichtbar ist
	if not password_layer.visible: return

	if text == CORRECT_PASSWORD:
		if computer_bing_player: computer_bing_player.play()
		image3.texture = load("res://graphics/work/computer_4.png")
		password_layer.hide()
		if submit_button: submit_button.hide()
		DisplayServer.virtual_keyboard_hide()
		_check_finished()
	else:
		# Bei Fehlern Tastatur offen halten
		password_input.text = ""
		_trigger_mobile_input()

func _on_image_close(_viewport, event, _shape_idx, img):
	if _is_input_action(event):
		if computer_klick_player: computer_klick_player.play()
		img.hide()
		
		# Wenn man das Passwort-Feld durch das Schließen eines Bildes "freilegt"
		# geben wir ihm am Handy automatisch den Fokus
		if not image1.visible and not image2.visible and password_layer.visible:
			_trigger_mobile_input()
			
		_check_finished()

func _trigger_mobile_input():
	# Nur triggern, wenn wir wirklich auf dem Handy sind und das Feld da ist
	if not password_layer.visible: return
	
	await get_tree().create_timer(0.1).timeout
	password_input.grab_focus()
	if DisplayServer.has_feature(DisplayServer.FEATURE_VIRTUAL_KEYBOARD):
		DisplayServer.virtual_keyboard_show(password_input.text, Rect2(), 2, -1, 7)

func _on_password_close(_viewport, event, _shape_idx):
	if _is_input_action(event):
		if computer_klick_player: computer_klick_player.play()
		password_layer.hide()
		if submit_button: submit_button.hide()
		DisplayServer.virtual_keyboard_hide()
		_check_finished()

func _check_finished():
	# Schließt das gesamte Overlay erst, wenn ALLES (Bilder & Passwort) weg ist
	if not image1.visible and not image2.visible and not image3.visible and not password_layer.visible:
		if computer_off_player: computer_off_player.play()
		hide()
		_set_hotspots_disabled(false)

func _set_hotspots_disabled(disabled: bool):
	if hotspots_root:
		for h in hotspots_root.get_children():
			if h is Area2D: h.input_pickable = not disabled

func _is_input_action(event) -> bool:
	return (event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT) or (event is InputEventScreenTouch and event.pressed)
