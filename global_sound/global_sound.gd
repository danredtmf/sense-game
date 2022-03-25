extends Node

var corridor = preload("res://sources/audio/music/bs_corridor.ogg")
var silence = preload("res://sources/audio/music/bs_silence.ogg")
var smile_full = preload("res://sources/audio/music/bs_smile_full.ogg")
var smile = preload("res://sources/audio/music/bs_smile.ogg")

var smile_jump = preload("res://sources/audio/sounds/smile_jump.wav")
var jump_1 = preload("res://sources/audio/sounds/jump_1.wav")
var jump_2 = preload("res://sources/audio/sounds/jump_2.wav")

onready var sound = $sound
onready var sound_extra = $sound_extra
onready var music = $music
onready var ambient = $ambient

func _ready():
	if AudioServer.get_bus_volume_db(Core.music_idx) == -24:
		AudioServer.set_bus_mute(Core.music_idx, true)
	else:
		AudioServer.set_bus_mute(Core.music_idx, false)
	
	if AudioServer.get_bus_volume_db(Core.sound_idx) == -24:
		AudioServer.set_bus_mute(Core.sound_idx, true)
	else:
		AudioServer.set_bus_mute(Core.sound_idx, false)

func play_ambient(ambient_name):
	if ambient.stream != null:
		ambient.stop()
	
	if ambient_name == 'corridor':
		ambient.stream = corridor
		ambient.play()
	elif ambient_name == 'silence':
		ambient.stream = silence
		ambient.play()

func stop_ambient():
	ambient.stop()

func play_music(music_name):
	if music.stream != null:
		music.stop()
	
	if music_name == 'smile':
		music.stream = smile
		music.play()
	elif music_name == 'smile_full':
		music.stream = smile_full
		music.play()

func pause_music(value):
	music.stream_paused = value

func stop_music():
	music.stop()

func play_sound(sound_name):
	if sound.stream != null:
		sound.stop()
	if sound_extra != null:
		sound_extra.stop()
	
	if sound_name == 'smile_jump':
		sound.stream = smile_jump
		sound.play()
	elif sound_name == 'jump':
		sound.stream = jump_1
		sound_extra.stream = jump_2
		sound.play()
		sound_extra.play()

func stop_sound(sound_track = 1):
	if sound_track == 1:
		sound.stop()
	elif sound_track == 2:
		sound_extra.stop()
	elif sound_track == 0:
		sound.stop()
		sound_extra.stop()

func start_fade(duration):
	$tween.interpolate_property(music, 'volume_db', -10, -24, duration,
		Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	$tween.start()

func stop_anim():
	$tween.stop_all()
	music.volume_db = -10

func stop_all_audio():
	stop_sound(0)
	stop_music()
	stop_ambient()
	stop_anim()

func _on_tween_tween_all_completed():
	music.volume_db = -10
