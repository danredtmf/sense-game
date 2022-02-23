extends Node

var is_ending = false
var is_good_ending = false
var is_game_passed = false
var saved_pos_player = Vector3.ZERO
var saved_notes = []
var saved_insights = []

enum LANG {ENGLISH = 0, RUSSIAN = 1}

var saved_mouse_sensitivity = 0.2
var saved_fullscreen_mode = true
var saved_language = LANG.ENGLISH

var data

func _ready():
	loading()
	loading_settings()

func packing(action_id, id = 0):
	if action_id == 'note' && id != 0:
		saved_notes.append(id)
	elif action_id == 'insight' && id != 0:
		saved_insights.append(id)
	print('saved_notes', saved_notes)
	print('saved_insights', saved_insights)

func open_note(id):
	return [tr('note_'+str(id)), tr('note_'+str(id)+'_text')]

func reset_game():
	is_ending = false
	is_good_ending = false
	is_game_passed = false
	saved_pos_player = Vector3.ZERO
	saved_notes = []
	saved_insights = []
	saving()

func reset_settings():
	saved_mouse_sensitivity = 0.2
	saved_fullscreen_mode = true
	saved_language = LANG.ENGLISH
	saving_settings()

func saving_settings():
	data = {
		'fullscreen': saved_fullscreen_mode,
		'sensitivity': saved_mouse_sensitivity,
		'lang': saved_language,
	}
	
	var file = File.new()
	file.open("user://settings.data", File.WRITE)
	var json = to_json(data)
	file.store_line(json)
	file.close()

func loading_settings():
	data = null
	
	var dir = Directory.new()
	if dir.file_exists("user://settings.data"):
		var file = File.new()
		file.open("user://settings.data", File.READ)
		data = parse_json(file.get_as_text())
		file.close()
	
	if data:
		saved_fullscreen_mode = data.fullscreen
		saved_mouse_sensitivity = data.sensitivity
		saved_language = data.lang

func saving():
	data = {
	'is_ending': is_ending,
	'is_good_ending': is_good_ending,
	'is_game_passed': is_game_passed,
	'saved_pos_player': [saved_pos_player.x, saved_pos_player.y, saved_pos_player.z],
	'saved_notes': saved_notes,
	'saved_insights': saved_insights,
	}
	
	var file = File.new()
	file.open("user://save.data", File.WRITE)
	var json = to_json(data)
	file.store_line(json)
	file.close()

func loading():
	data = null
	
	var dir = Directory.new()
	if dir.file_exists("user://save.data"):
		var file = File.new()
		file.open("user://save.data", File.READ)
		data = parse_json(file.get_as_text())
		file.close()
	
	if data:
		is_ending = data.is_ending
		is_good_ending = data.is_good_ending
		is_game_passed = data.is_game_passed
		saved_pos_player = Vector3(data.saved_pos_player[0], data.saved_pos_player[1], data.saved_pos_player[2])
		saved_notes = data.saved_notes
		saved_insights = data.saved_insights
