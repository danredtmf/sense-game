extends Control

onready var settings_name = $name
onready var fullscr_name = $scroll/container/margin/grid/fullscr/margin/fullscr/panel1/margin/name
onready var lang_name = $scroll/container/margin/grid/lang/margin/lang/panel1/margin/name
onready var sns_name = $scroll/container/margin/grid/sns/margin/sns/panel1/margin/name
onready var fps_name = $scroll/container/margin/grid/fps/margin/fps/panel1/margin/name
onready var vsync_name = $scroll/container/margin/grid/vsync/margin/vsync/panel1/margin/name
onready var data_name = $scroll/container/margin/grid/data/margin/data/panel/margin/name
onready var audio_name = $scroll/container/margin/grid/audio/margin/audio/panel/margin/name
onready var music_name = $scroll/container/margin/grid/audio/margin/audio/audio/music/panel1/margin/name
onready var sound_name = $scroll/container/margin/grid/audio/margin/audio/audio/sound/panel1/margin/name

onready var lang_opts = $scroll/container/margin/grid/lang/margin/lang/panel2/margin/lang_opts
onready var reset_game = $scroll/container/margin/grid/data/margin/data/data/panel1/margin/reset_game
onready var reset_settings = $scroll/container/margin/grid/data/margin/data/data/panel2/margin/reset_settings
onready var fullscr = $scroll/container/margin/grid/fullscr/margin/fullscr/panel2/fullscr
onready var sns = $scroll/container/margin/grid/sns/margin/sns/panel2/margin/sns
onready var fps = $scroll/container/margin/grid/fps/margin/fps/panel2/fps
onready var vsync = $scroll/container/margin/grid/vsync/margin/vsync/panel2/vsync
onready var music = $scroll/container/margin/grid/audio/margin/audio/audio/music/panel2/margin/music
onready var sound = $scroll/container/margin/grid/audio/margin/audio/audio/sound/panel2/margin/sound

onready var sns_value = $scroll/container/margin/grid/sns/margin/sns/panel3/value
onready var music_value = $scroll/container/margin/grid/audio/margin/audio/audio/music/panel3/value
onready var sound_value = $scroll/container/margin/grid/audio/margin/audio/audio/sound/panel3/value

onready var reset_game_panel = $scroll/container/margin/grid/data/margin/data/data/panel1

func _ready():
	update_ui()

func update_ui():
	if Data.saved_language == 0:
		TranslationServer.set_locale('en')
	elif Data.saved_language == 1:
		TranslationServer.set_locale('ru')
	
	settings_name.text = tr('settings')
	fullscr_name.text = tr('fullscreen')
	lang_name.text = tr('set_language')
	sns_name.text = tr('mouse_sensitivity')
	fps_name.text = tr('fps_monitor')
	vsync_name.text = tr('vsync')
	data_name.text = tr('data')
	audio_name.text = tr('audio')
	music_name.text = tr('music')
	sound_name.text = tr('sound')
	
	lang_opts.set_item_text(0, tr('english'))
	lang_opts.set_item_text(1, tr('russian'))
	
	if Data.saved_fullscreen_mode:
		fullscr.text = tr('on')
	else:
		fullscr.text = tr('off')
	
	if Data.saved_vsync:
		vsync.text = tr('on')
	else:
		vsync.text = tr('off')
	
	if Data.saved_performance_monitor:
		fps.text = tr('on')
	else:
		fps.text = tr('off')
	
	reset_game.text = tr('reset_game')
	reset_settings.text = tr('reset_settings')
	
	$close.text = tr('close')
	
	fullscr.pressed = Data.saved_fullscreen_mode
	sns.value = Data.saved_mouse_sensitivity
	lang_opts.selected = Data.saved_language
	fps.pressed = Data.saved_performance_monitor
	vsync.pressed = Data.saved_vsync
	
	music.value = Data.saved_music_volume
	sound.value = Data.saved_sound_volume

func _process(_delta):
	sns_value.text = str(sns.value)
	music_value.text = str(
		int(
			lerp(0, 1, 
			((music.value + -music.min_value) * 100) / -music.min_value)
		)
	) + ' %'
	sound_value.text = str(
		int(
			lerp(0, 1, 
			((sound.value + -sound.min_value) * 100) / -sound.min_value)
		)
	) + ' %'
	
	if get_tree().paused:
		reset_game_panel.visible = false
	else:
		reset_game_panel.visible = true

func _on_reset_game_pressed():
	Data.reset_game()
	update_ui()

func _on_reset_settings_pressed():
	Data.reset_settings()
	update_ui()

func _on_close_pressed():
	if is_instance_valid(Core.root_menu):
		Core.root_menu.menu.view.visible = true
	queue_free()

func _on_lang_opts_item_selected(index):
	Data.saved_language = index
	Data.saving_settings()
	update_ui()

func _on_sns_value_changed(value):
	Data.saved_mouse_sensitivity = value
	Data.saving_settings()

func _on_fullscr_pressed():
	Data.saved_fullscreen_mode = fullscr.pressed
	OS.window_fullscreen = Data.saved_fullscreen_mode
	Data.saving_settings()
	update_ui()

func _on_vsync_pressed():
	Data.saved_vsync = vsync.pressed
	OS.vsync_enabled = Data.saved_vsync
	Data.saving_settings()
	update_ui()

func _on_fps_pressed():
	Data.saved_performance_monitor = fps.pressed
	Data.saving_settings()
	update_ui()

func _on_music_value_changed(value):
	Data.saved_music_volume = value
	if value > music.min_value:
		AudioServer.set_bus_mute(Core.music_idx, false)
		AudioServer.set_bus_volume_db(Core.music_idx, Data.saved_music_volume)
	else:
		AudioServer.set_bus_mute(Core.music_idx, true)
	Data.saving_settings()
	update_ui()

func _on_sound_value_changed(value):
	Data.saved_sound_volume = value
	if value > sound.min_value:
		AudioServer.set_bus_mute(Core.sound_idx, false)
		AudioServer.set_bus_volume_db(Core.sound_idx, Data.saved_sound_volume)
	else:
		AudioServer.set_bus_mute(Core.sound_idx, true)
	Data.saving_settings()
	update_ui()

func _on_audio_resized():
	print($scroll/container/margin/grid/audio.rect_size)
