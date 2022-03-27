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
	
	$information/HBox/links/links.text = tr('used_resources') + ':'
	$information/HBox/links/jumpscare.text = tr('jumpscare_sounds') + ':'
	$information/HBox/links/jumpscare_link/link_smile_jump.text = tr('sound') + ' 1'
	$information/HBox/links/jumpscare_link/link_jump1.text = tr('sound') + ' 2'
	$information/HBox/links/jumpscare_link/link_jump2.text = tr('sound') + ' 3'
	$information/HBox/links/steps.text = tr('footsteps') + ':'
	$information/HBox/links/steps_link/link_smile_step.text = tr('smile')
	$information/HBox/links/steps_link/link_player_step.text = tr('player')
	$information/HBox/links/link_heartbeat.text = tr('heartbeat_sound')
	$information/HBox/links/textures.text = tr('textures') + ':'
	$information/HBox/links/textures_link/link_floor.text = tr('floor')
	$information/HBox/links/textures_link/link_wall.text = tr('wall')
	$information/HBox/links/textures_link/link_roof.text = tr('ceiling')

func _on_close_pressed():
	if is_instance_valid(Core.root_menu):
		Core.root_menu.view.visible = true
	queue_free()

func _on_logo_dev_pressed():
# warning-ignore:return_value_discarded
	OS.shell_open("https://danredtmf.github.io")

func _on_logo_music_pressed():
# warning-ignore:return_value_discarded
	OS.shell_open("https://www.youtube.com/channel/UCD3JB_BSDS92-rzYrFHg7fg")

func _on_link_smile_step_pressed():
# warning-ignore:return_value_discarded
	OS.shell_open('https://freesound.org/s/76187/')

func _on_link_player_step_pressed():
# warning-ignore:return_value_discarded
	OS.shell_open('https://freesound.org/s/563473/')

func _on_link_heartbeat_pressed():
# warning-ignore:return_value_discarded
	OS.shell_open('https://freesound.org/s/323714/')

func _on_link_smile_jump_pressed():
# warning-ignore:return_value_discarded
	OS.shell_open('https://freesound.org/s/502551/')

func _on_link_jump1_pressed():
# warning-ignore:return_value_discarded
	OS.shell_open('https://freesound.org/s/393824/')

func _on_link_jump2_pressed():
# warning-ignore:return_value_discarded
	OS.shell_open('https://freesound.org/s/491210/')

func _on_link_floor_pressed():
# warning-ignore:return_value_discarded
	OS.shell_open('https://www.pinterest.com.au/pin/89649848811605607/')

func _on_link_wall_pressed():
# warning-ignore:return_value_discarded
	OS.shell_open('https://www.pinterest.ru/pin/468233692485035546/')

func _on_link_roof_pressed():
# warning-ignore:return_value_discarded
	OS.shell_open('https://www.pinterest.de/pin/escape-wild-hunt-team-oldschool-page-4-polycount-forum--315322411380543955/')
