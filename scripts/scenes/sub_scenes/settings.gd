extends Control

func _ready():
	update_ui()

func update_ui():
	if Data.saved_language == 0:
		TranslationServer.set_locale('en')
	elif Data.saved_language == 1:
		TranslationServer.set_locale('ru')
	
	OS.window_fullscreen = Data.saved_fullscreen_mode
	
	$name.text = tr('settings')
	$vbox/box_fullscreen/name_fullscreen.text = tr('fullscreen')
	$vbox/box_language/name_language.text = tr('set_language')
	$vbox/box_sensitivity/name_sensitivity.text = tr('mouse_sensitivity')
	$vbox/box_language/OptionButton.set_item_text(0, tr('english'))
	$vbox/box_language/OptionButton.set_item_text(1, tr('russian'))
	$vbox/box_perfomance_monitor/name_perfomance_monitor.text = tr('fps_monitor')
	$vbox/box_vsync/name_vsync.text = tr('vsync')
	$vbox/box_data/reset_game.text = tr('reset_game')
	$vbox/box_data/reset_settings.text = tr('reset_settings')
	$close.text = tr('close')
	
	$vbox/box_fullscreen/CheckBox.pressed = Data.saved_fullscreen_mode
	$vbox/box_sensitivity/HSlider.value = Data.saved_mouse_sensitivity
	$vbox/box_language/OptionButton.selected = Data.saved_language
	$vbox/box_perfomance_monitor/check_perfomance_monitor.pressed = Data.saved_performance_monitor
	$vbox/box_vsync/check_vsync.pressed = Data.saved_vsync

func _process(_delta):
	$vbox/box_sensitivity/sens_text.text = str($vbox/box_sensitivity/HSlider.value)
	
	if get_tree().paused:
		$vbox/box_data/reset_game.visible = false
	else:
		$vbox/box_data/reset_game.visible = true

func _on_CheckBox_pressed():
	Data.saved_fullscreen_mode = $vbox/box_fullscreen/CheckBox.pressed
	OS.window_fullscreen = Data.saved_fullscreen_mode
	Data.saving_settings()

func _on_HSlider_value_changed(value):
	Data.saved_mouse_sensitivity = value
	Data.saving_settings()

func _on_OptionButton_item_selected(index):
	Data.saved_language = index
	Data.saving_settings()
	update_ui()

func _on_reset_game_pressed():
	Data.reset_game()
	update_ui()

func _on_reset_settings_pressed():
	Data.reset_settings()
	update_ui()

func _on_close_pressed():
	queue_free()

func _on_check_perfomance_monitor_pressed():
	Data.saved_performance_monitor = $vbox/box_perfomance_monitor/check_perfomance_monitor.pressed
	Data.saving_settings()
	update_ui()

func _on_check_vsync_pressed():
	Data.saved_vsync = $vbox/box_vsync/check_vsync.pressed
	OS.vsync_enabled = Data.saved_vsync
	Data.saving_settings()
	update_ui()
