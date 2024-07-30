extends Control

signal start_transition

const settings_menu_res = preload("res://levels/scenes/sub_scenes/settings.tscn")
const about_menu_res = preload("res://levels/scenes/sub_scenes/about_interface.tscn")
const notes_viewer_res = preload("res://levels/scenes/sub_scenes/notes_viewer.tscn")

var state

onready var heartbeat = $screen_trigger
onready var anim = $anim
onready var view = $view_3d
onready var viewport = $view_3d/view

func _ready():
	Core.root_menu = self
# warning-ignore:return_value_discarded
	connect("start_transition", self, "_transition_start")
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if Data.saved_language == 0:
		TranslationServer.set_locale('en')
	elif Data.saved_language == 1:
		TranslationServer.set_locale('ru')
	
	if Core.splash_screen:
		emit_signal("start_transition")
	
	update_ui()

func _process(_delta):
	update_ui()

func _transition_start():
	anim.play("start")

func _perfomance_monitor():
	$perfomance_monitor.text = 'FPS: ' \
	+ str(Performance.get_monitor(Performance.TIME_FPS))

func update_ui():
	if Data.is_ending && !Data.is_game_passed:
		$Control/vbox/continue.visible = true
		$Control/vbox/notes.visible = true
	elif Data.is_ending && Data.is_game_passed:
		$Control/vbox/continue.visible = true
		$Control/vbox/notes.visible = true
	else:
		$Control/vbox/continue.visible = false
		$Control/vbox/notes.visible = false
	
	if Data.saved_performance_monitor:
		_perfomance_monitor()
	else:
		$perfomance_monitor.text = ''
	
	$Control/vbox/new_game.text = tr('new_game')
	$Control/vbox/continue.text = tr('continue')
	$Control/vbox/notes.text = tr('notes')
	$Control/vbox/settings.text = tr('settings')
	$Control/vbox/about.text = tr('about')
	$Control/vbox/exit.text = tr('exit')
	$version.text = ProjectSettings.get_setting('application/config/version') + ' '
	$warning_newgame/margin/vbox/warning.text = tr('warning') + "!"
	$warning_newgame/margin/vbox/info_warning_newgame.text = tr('info_warning')
	$warning_newgame/margin/vbox/buttons/agree.text = tr('agree')
	$warning_newgame/margin/vbox/buttons/disagree.text = tr('disagree')

func _on_anim_animation_finished(anim_name):
	if anim_name == 'end' && state == null:
		Core.to('game')
		Data.reset_game()
		GlobalSound.stop_sound()
	elif anim_name == 'end' && state == 1:
		Core.to('game')
		GlobalSound.stop_sound()

func _on_new_game_pressed():
	if !Data.is_ending:
		$anim.play("end")
	else:
		$warning_newgame.popup()

func _on_continue_pressed():
	state = 1
	$anim.play("end")

func _on_settings_pressed():
	var settings = settings_menu_res.instance()
	get_tree().root.add_child(settings)
	settings.connect("win_size_update", self, "_on_win_size_update")
	
	view.visible = false

func _on_about_pressed():
	var about = about_menu_res.instance()
	get_tree().root.add_child(about)
	
	view.visible = false

func _on_exit_pressed():
	Core.exit()

func _on_agree_pressed():
	if Data.is_ending:
		$anim.play("end")
		$warning_newgame.hide()

func _on_disagree_pressed():
	$warning_newgame.hide()

func _on_notes_pressed():
	var notes = notes_viewer_res.instance()
	get_tree().root.add_child(notes)
	
	view.visible = false

func _on_win_size_update():
	if is_instance_valid(viewport):
		var win_size = OS.window_size
		if OS.window_maximized:
			if viewport.size != OS.get_screen_size():
				viewport.size = OS.get_screen_size()
		else:
			if viewport.size != win_size:
				viewport.size = win_size

func _on_TimerUpdateViewportSize_timeout():
	_on_win_size_update()
