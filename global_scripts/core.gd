extends Node

var level = 1
var root_menu
var root_level
var root_nav
var root_game
var root_player
var root_gui
var root_jump_map

var action_object = null
var action_object_viewing = false

var game_pause = false
var splash_screen = false

onready var music_idx = AudioServer.get_bus_index('Music')
onready var sound_idx = AudioServer.get_bus_index('Sound')

func _ready():
	randomize()
	Data.loading()
	Data.loading_settings()
	get_tree().paused = true
	OS.window_fullscreen = Data.saved_fullscreen_mode
	OS.vsync_enabled = Data.saved_vsync
	AudioServer.set_bus_volume_db(Core.music_idx, Data.saved_music_volume)
	AudioServer.set_bus_volume_db(Core.sound_idx, Data.saved_sound_volume)
	OS.center_window()

func to(scene):
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://levels/scenes/"+scene+".tscn")
	if scene != 'credits':
		Data.is_picked_lie_insight = false
	Data.is_created_smile = false

func exit():
	get_tree().quit()
