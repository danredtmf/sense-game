extends Spatial

func _ready():
	Core.root_level = self
	Core.root_nav = $Navigation
	$RoomManager.rooms_convert()
