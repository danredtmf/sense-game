extends Node

var level = 1
var root_menu
var root_level
var root_game
var root_player
var root_gui

var action_object = null
var action_object_viewing = false

var game_pause = false

func _ready():
	randomize()
	OS.center_window()

func to(scene):
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://levels/scenes/"+scene+".tscn")

func load_level():
	root_level = load("res://levels/level_"+str(level)+"/level.tscn").instance()
	root_game.get_node('level').add_child(root_level)

func exit():
	get_tree().quit()
