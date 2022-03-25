extends Control

var current_note = 0
var notes : Array

func _ready():
	notes = Data.saved_notes
	notes.sort()
	get_note()
	update_ui()
	check_state_btns()

func update_ui():
	$previous_btn.text = tr('previous_note')
	$next_btn.text = tr('next_note')
	$close_btn.text = tr('close')

func get_note():
	if current_note < len(notes):
		$name.text = tr('note_'+str(notes[current_note]))
		$pic/text.text = tr('note_'+str(notes[current_note])+'_text')
	else:
		$name.text = tr('notes')
		$pic/text.text = tr('notes_no')

func check_state_btns():
	if current_note - 1 > -1:
		$previous_btn.disabled = false
	else:
		$previous_btn.disabled = true
	if current_note + 1 < len(notes):
		$next_btn.disabled = false
	else:
		$next_btn.disabled = true

func _on_previous_btn_pressed():
	if current_note - 1 > -1:
		current_note -= 1
		get_note()
		check_state_btns()

func _on_next_btn_pressed():
	if current_note + 1 < len(notes):
		current_note += 1
		get_note()
		check_state_btns()

func _on_close_btn_pressed():
	if is_instance_valid(Core.root_menu):
		Core.root_menu.menu.view.visible = true
	queue_free()
