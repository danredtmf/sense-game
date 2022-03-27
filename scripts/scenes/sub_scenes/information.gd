extends Label

# warning-ignore:unused_signal
signal showing

func _ready():
# warning-ignore:return_value_discarded
	connect("showing", self, "_showing")

func _process(_delta):
	update_ui()

func update_ui():
	if is_instance_valid(Core.action_object) \
	&& 'action_name' in Core.action_object:
		if !Data.is_good_ending:
			if Core.action_object.action_id == 'book':
				text = tr('info_book')

func _showing():
	if !$anim.is_playing():
		set_process(true)
		$anim.play('start')
		update_ui()

func _on_anim_animation_finished(_anim_name):
	set_process(false)
