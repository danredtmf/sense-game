extends Node

var is_ending = false
var is_good_ending = false
var is_main_menu_jampscare_done = false
var is_game_passed = false
var saved_pos_player = Vector3.ZERO
var saved_notes = []
var saved_insights = []

var is_picked_lie_insight = false
var is_created_smile = false

enum LANG {ENGLISH = 0, RUSSIAN = 1}

var saved_mouse_sensitivity = 0.2
var saved_fullscreen_mode = true
var saved_language = LANG.ENGLISH
var saved_performance_monitor = false
var saved_vsync = true
var saved_music_volume : float
var saved_sound_volume : float

var data

func packing(action_id, id = 0):
	if action_id == 'note' && id != 0:
		saved_notes.append(id)
	elif action_id == 'insight' && id != 0:
		saved_insights.append(id)
#	print('saved_notes', saved_notes)
#	print('saved_insights', saved_insights)

func open_note(id):
	return [tr('note_'+str(id)), tr('note_'+str(id)+'_text')]

func reset_game():
	is_ending = false
	is_good_ending = false
	is_main_menu_jampscare_done = false
	is_game_passed = false
	saved_pos_player = Vector3.ZERO
	saved_notes = []
	saved_insights = []
	saving()

func reset_settings():
	saved_mouse_sensitivity = 0.2
	saved_fullscreen_mode = true
	saved_language = LANG.ENGLISH
	saved_performance_monitor = false
	saved_vsync = true
	AudioServer.set_bus_volume_db(Core.music_idx, 0)
	AudioServer.set_bus_volume_db(Core.sound_idx, 0)
	saved_music_volume = AudioServer.get_bus_volume_db(Core.music_idx)
	saved_sound_volume = AudioServer.get_bus_volume_db(Core.sound_idx)
	OS.window_fullscreen = saved_fullscreen_mode
	saving_settings()

func saving_settings():
	data = {
		'fullscreen': saved_fullscreen_mode,
		'sensitivity': saved_mouse_sensitivity,
		'lang': saved_language,
		'performance_monitor': saved_performance_monitor,
		'vsync': saved_vsync,
		'saved_music_volume': saved_music_volume,
		'saved_sound_volume': saved_sound_volume,
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
		if 'fullscreen' in data:
			saved_fullscreen_mode = data.fullscreen
		if 'sensitivity' in data:
			saved_mouse_sensitivity = data.sensitivity
		if 'lang' in data:
			saved_language = data.lang
		if 'performance_monitor' in data:
			saved_performance_monitor = data.performance_monitor
		if 'vsync' in data:
			saved_vsync = data.vsync
		if 'saved_music_volume' in data:
			saved_music_volume = data.saved_music_volume
		else:
			saved_music_volume = AudioServer.get_bus_volume_db(Core.music_idx)
		if 'saved_sound_volume' in data:
			saved_sound_volume = data.saved_sound_volume
		else:
			saved_sound_volume = AudioServer.get_bus_volume_db(Core.sound_idx)

func saving():
	data = {
	'is_ending': is_ending,
	'is_good_ending': is_good_ending,
	'is_main_menu_jampscare_done': is_main_menu_jampscare_done,
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
		if 'is_ending' in data:
			is_ending = data.is_ending
		if 'is_good_ending' in data:
			is_good_ending = data.is_good_ending
		if 'is_main_menu_jampscare_done' in data:
			is_main_menu_jampscare_done = data.is_main_menu_jampscare_done
		if 'is_game_passed' in data:
			is_game_passed = data.is_game_passed
		if 'saved_pos_player' in data:
			saved_pos_player = Vector3(data.saved_pos_player[0], data.saved_pos_player[1], data.saved_pos_player[2])
		if 'saved_notes' in data:
			saved_notes = data.saved_notes
		if 'saved_insights' in data:
			saved_insights = data.saved_insights
