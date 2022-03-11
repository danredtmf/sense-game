extends Label

signal showing

func _ready():
# warning-ignore:return_value_discarded
	connect("showing", self, "_showing")
	emit_signal("showing")

func _process(_delta):
	update_ui()

func update_ui():
	var pickup_notes = Data.saved_notes.size()
	var pickup_insights = Data.saved_insights.size()
	
	if Data.is_good_ending:
		text = tr('notes') + ': ' + str(pickup_notes) + '/' + '8' + '\n'\
			+ tr('insights') + ': ' + str(pickup_insights) + '/' + '6'
	else:
		text = tr('notes') + ': ' + str(pickup_notes) + '/' + '5' + '\n'\
			+ tr('insights') + ': ' + str(pickup_insights) + '/' + '6'

func _showing():
	if !$anim.is_playing():
		set_process(true)
		$anim.play('start')
		update_ui()

# warning-ignore:unused_argument
func _on_anim_animation_finished(anim_name):
	set_process(false)
