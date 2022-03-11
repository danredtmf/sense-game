extends Control

func _ready():
	if !Core.splash_screen:
		yield(get_tree().create_timer(1), "timeout")
		$anim.play("start")
	else:
		visible = false

func _on_anim_animation_finished(anim_name):
	if anim_name == 'start':
		get_tree().paused = false
		Core.splash_screen = true
		Core.root_menu.menu.emit_signal('start_transition')
		$anim.play("end")
	elif anim_name == 'end':
		visible = false
