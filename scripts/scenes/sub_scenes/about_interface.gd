extends Control

func _ready():
	update_ui()

func update_ui():
	$version.text = ProjectSettings.get_setting('application/config/version') + " "
	$name.text = tr('about')
	$information/HBox/info_control/control_name.text = tr('about_control') + ':'
	$information/HBox/info_control/info_movement.text = tr('about_movement')
	$information/HBox/info_control/info_items.text = tr('about_pickup_items')
	$information/HBox/info_control/info_interacting.text = tr('about_interact')
	$information/HBox/info_control/info_flashlight.text = tr('about_flashlight')
	$information/HBox/info_control/info_ranning.text = tr('about_run')
	$information/HBox/info_control/info_pause_menu.text = tr('about_pause')
	$close.text = tr('close')

func _on_close_pressed():
	queue_free()

func _on_logo_dev_pressed():
# warning-ignore:return_value_discarded
	OS.shell_open("https://danredtmf.github.io")

func _on_logo_music_pressed():
# warning-ignore:return_value_discarded
	OS.shell_open("https://www.youtube.com/channel/UCD3JB_BSDS92-rzYrFHg7fg")
