extends Node

onready var sound = $sound
onready var music = $music

func _ready():
	if AudioServer.get_bus_volume_db(Core.music_idx) == -24:
		AudioServer.set_bus_mute(Core.music_idx, true)
	else:
		AudioServer.set_bus_mute(Core.music_idx, false)
	
	if AudioServer.get_bus_volume_db(Core.sound_idx) == -24:
		AudioServer.set_bus_mute(Core.sound_idx, true)
	else:
		AudioServer.set_bus_mute(Core.sound_idx, false)
