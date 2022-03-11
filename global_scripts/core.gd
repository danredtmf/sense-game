extends Node

var level = 1
var root_menu
var root_level
var root_nav
var root_game
var root_player
var root_gui

var action_object = null
var action_object_viewing = false

var game_pause = false
var splash_screen = false

func _ready():
	randomize()
	Data.loading()
	Data.loading_settings()
	get_tree().paused = true
	OS.window_fullscreen = Data.saved_fullscreen_mode
	OS.vsync_enabled = Data.saved_vsync
	OS.center_window()

func to(scene):
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://levels/scenes/"+scene+".tscn")
	if scene != 'credits':
		Data.is_picked_lie_insight = false
	Data.is_created_smile = false

func exit():
	get_tree().quit()
