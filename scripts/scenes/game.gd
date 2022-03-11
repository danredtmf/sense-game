extends Node

func _ready():
	Core.root_game = self
	Data.is_picked_lie_insight = false
	Data.is_created_smile = false
	SceneChanger.goto_scene("res://levels/level_1/level.tscn")
