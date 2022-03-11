extends Spatial

var is_anim = false
var is_reverse = false

onready var pos_note = $pos_note

func move():
	if !is_anim:
		if !is_reverse:
			$anim.play('move')
			is_reverse = true
		else:
			$anim.play_backwards("move")
			is_reverse = false
		is_anim = true

func _on_anim_animation_finished(_anim_name):
	is_anim = false
