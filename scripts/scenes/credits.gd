extends Control

var state = 0

func _ready():
	$timer_delay.start()

# warning-ignore:unused_argument
func _on_anim_animation_finished(anim_name):
	state = 1
	$timer_delay.start()

func _on_anim_credits_animation_finished(anim_name):
	if anim_name == 'ending':
		$anim_credits.play("people")
	elif anim_name == 'people':
		if Data.is_picked_lie_insight:
			$end/result_text.text = 'Вы попались в ловушку.'
		elif Data.is_good_ending && !Data.is_game_passed:
			$end/result_text.text = 'Всё ещё остались секреты...'
		elif Data.is_good_ending && Data.is_game_passed:
			$end/result_text.text = 'Спасибо за игру!'
		$anim_credits.play("end")
	elif anim_name == 'end':
		state = 2
		$timer_delay.start()

func _on_timer_delay_timeout():
	if state == 0 && Data.is_picked_lie_insight:
		$bad_text.text = 'Trap'
		$anim.play("to_black_jump")
	elif state == 0 && Data.is_good_ending:
		$anim.play("to_black")
	elif state == 1:
		if Data.is_picked_lie_insight:
			$ending/type_ending.text = 'Bad Ending'
		elif Data.is_good_ending && !Data.is_game_passed:
			$ending/type_ending.text = 'Good Ending'
		elif Data.is_good_ending && Data.is_game_passed:
			$ending/type_ending.text = 'True Ending'
		$anim_credits.play("ending")
	elif state == 2:
		Core.to('main_menu')
