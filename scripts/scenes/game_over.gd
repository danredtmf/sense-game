extends Control

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	$text.text = tr('game_over')
	$view_jump/Viewport/jumpscare_map.smile.start_attack()
	GlobalSound.play_sound('jump')
	$jp_timer.start()
	yield(get_tree().create_timer(2), "timeout")
	$anim.play("start")

func _on_anim_animation_finished(_anim_name):
	yield(get_tree().create_timer(2), "timeout")
	Core.to('main_menu')
	
	GlobalSound.stop_all_audio()
	
	Data.loading()
	Data.loading_settings()

func _on_jp_timer_timeout():
	$view_jump.visible = false
