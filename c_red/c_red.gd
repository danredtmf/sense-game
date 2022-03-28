extends Spatial

export var anim = ''
export var is_illusion = false

func _ready():
	if anim != '':
		$AnimationPlayer.play(anim)

func _on_AnimationPlayer_animation_finished(anim_name):
	if $AnimationPlayer.get_animation('idle').loop == false \
	&& anim_name == 'idle':
		queue_free()
	elif anim_name == 'turning_right':
		queue_free()

func _on_VisibilityNotifier_camera_entered(_camera):
	if is_illusion:
		$timer_delay_destroy.start()

func _on_timer_delay_destroy_timeout():
	queue_free()

func _on_area_proximity_body_entered(body):
	if body.name == 'player':
		queue_free()
