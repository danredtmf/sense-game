extends Control

const settings_menu_res = preload("res://levels/scenes/sub_scenes/settings.tscn")

func _ready():
	update_ui()

func _process(_delta):
	update_ui()

func update_ui():
	$name.text = tr('pause')
	$buttons/VBoxContainer/continue.text = tr('continue')
	$buttons/VBoxContainer/settings.text = tr('settings')
	$buttons/VBoxContainer/exit.text = tr('exit')

func _on_continue_pressed():
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	queue_free()

func _on_exit_pressed():
	Core.root_gui.emit_signal('transition_scene', 'end')

func _on_settings_pressed():
	var settings = settings_menu_res.instance()
	get_parent().add_child(settings)
