extends Node

onready var view_3d = $Viewport
onready var menu = $interface

func _ready():
	Core.root_menu = self
