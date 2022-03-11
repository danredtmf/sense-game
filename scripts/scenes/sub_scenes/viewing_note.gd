extends Control

var note_id = 0
var note_name = ''
var note_text = ''

func _ready():
	get_tree().paused = true
	
	$close_btn.text = tr('close')
	
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	var list = Data.open_note(note_id)
	note_name = list[0]
	note_text = list[1]
	
	$name.text = note_name
	$pic/text.text = note_text

func _on_close_btn_pressed():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	get_tree().paused = false
	queue_free()
