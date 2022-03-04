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

func _ready():
	randomize()
	OS.window_fullscreen = Data.saved_fullscreen_mode
	OS.vsync_enabled = Data.saved_vsync
	OS.center_window()

func to(scene):
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://levels/scenes/"+scene+".tscn")
	Data.is_picked_lie_insight = false
	Data.is_created_smile = false

func load_level():
	root_level = load("res://levels/level_"+str(level)+"/level.tscn").instance()
	root_game.get_node('level').add_child(root_level)

func exit():
	get_tree().quit()
