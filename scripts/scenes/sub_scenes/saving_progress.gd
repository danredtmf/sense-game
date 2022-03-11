extends Control

# warning-ignore:unused_signal
signal showing

func _ready():
# warning-ignore:return_value_discarded
	connect("showing", self, "_showing")
	update_ui()

func _process(_delta):
	update_ui()

func update_ui():
	$text.text = tr('saving') + '...'

func _showing():
	if !$anim.is_playing():
		$anim.play("show")
