extends Area

func _on_flashlight_trigger_body_entered(body):
	if body.name == 'player':
		body.enable_flashlight = false
		body.call('check_flashlight')

func _on_flashlight_trigger_body_exited(body):
	if body.name == 'player':
		body.enable_flashlight = true
		body.call('check_flashlight')
