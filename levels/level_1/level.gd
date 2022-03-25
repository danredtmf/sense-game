extends Spatial

func _ready():
	Core.root_level = self
	Core.root_nav = $Navigation
	$RoomManager.rooms_convert()
	
	if !Data.is_good_ending:
		GlobalSound.play_ambient('corridor')
	else:
		GlobalSound.play_ambient('silence')
