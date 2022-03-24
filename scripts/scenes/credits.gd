extends Control

var state = 0

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	$timer_delay.start()

func _on_anim_animation_finished(_anim_name):
	state = 1
	$timer_delay.start()

func _on_anim_credits_animation_finished(anim_name):
	if anim_name == 'ending':
		$anim_credits.play("people")
	elif anim_name == 'people':
		if Data.is_picked_lie_insight || !Data.is_good_ending:
			$end/result_text.text = tr('result_bad_ending')
		elif Data.is_good_ending && !Data.is_game_passed:
			$end/result_text.text = tr('result_good_ending')
		elif Data.is_good_ending && Data.is_game_passed:
			$end/result_text.text = tr('result_true_ending')
		$anim_credits.play("end")
	elif anim_name == 'end':
		state = 2
		$timer_delay.start()

func _on_timer_delay_timeout():
	if state == 0 && Data.is_picked_lie_insight:
		$bad_text.text = tr('trap')
		GlobalSound.play_sound('jump')
		$anim.play("to_black_jump")
	elif state == 0 && Data.is_good_ending:
		$anim.play("to_black")
	elif state == 1:
		if Data.is_picked_lie_insight:
			$ending/type_ending.text = tr('bad_ending')
			GlobalSound.start_fade(20)
		elif Data.is_good_ending && !Data.is_game_passed:
			$ending/type_ending.text = tr('good_ending')
			GlobalSound.start_fade(20)
		elif Data.is_good_ending && Data.is_game_passed:
			$ending/type_ending.text = tr('true_ending')
			GlobalSound.start_fade(20)
		$anim_credits.play("ending")
	elif state == 2:
		yield(get_tree().create_timer(1), "timeout")
		Core.to('main_menu')
		
		GlobalSound.stop_music()
		GlobalSound.stop_sound(0)
		GlobalSound.stop_anim()
		
		Data.loading()
		Data.loading_settings()
