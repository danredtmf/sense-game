extends Control

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	$text.text = tr('game_over')
	GlobalSound.play_sound('jump')
	$jp_timer.start()
	yield(get_tree().create_timer(2), "timeout")
	$anim.play("start")

func _on_anim_animation_finished(_anim_name):
	yield(get_tree().create_timer(2), "timeout")
	Core.to('main_menu')
	
	Data.loading()
	Data.loading_settings()

func _on_jp_timer_timeout():
	$jumpscare.visible = false
