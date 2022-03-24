extends Control

# warning-ignore:unused_signal
signal showing_action_object
# warning-ignore:unused_signal
signal showing_pause
# warning-ignore:unused_signal
signal transition_scene(anim_name)

const viewing_note_res = preload("res://levels/scenes/sub_scenes/viewing_note.tscn")
const pause_menu_res = preload("res://levels/scenes/sub_scenes/game_pause.tscn")

onready var heartbeat = $screen_trigger
onready var saving_progress = $saving_progress
onready var inventory = $inventory

func _ready():
	Core.root_gui = self
# warning-ignore:return_value_discarded
	connect("showing_action_object", self, "_showing_action_object")
# warning-ignore:return_value_discarded
	connect("showing_pause", self, "_showing_pause")
# warning-ignore:return_value_discarded
	connect("transition_scene", self, "_transition_scene")

func _process(_delta):
	if Data.saved_performance_monitor:
		_perfomance_monitor()
	else:
		$perfomance_monitor.text = ''

func set_action_name(name):
	$action_name.text = name
	if name == '':
		$back_text.hide()
	else:
		$back_text.show()

func _perfomance_monitor():
	$perfomance_monitor.text = 'FPS: ' \
	+ str(Performance.get_monitor(Performance.TIME_FPS))

func _showing_action_object():
	if !Core.action_object:
		set_action_name('')
	elif is_instance_valid(Core.action_object) && 'action_name' in Core.action_object:
		set_action_name(Core.action_object.action_name)
		if Core.action_object.action_viewing && Core.action_object.id != 0:
			if Core.action_object_viewing:
				var view_note = viewing_note_res.instance()
				view_note.note_id = Core.action_object.id
				add_child(view_note)
				Core.action_object_viewing = false

func _showing_pause():
	if Core.game_pause:
		var pause = pause_menu_res.instance()
		add_child_below_node($action_name, pause)
		Core.game_pause = false

func _transition_scene(anim_name):
	$anim.play(anim_name)

func _on_anim_animation_finished(anim_name):
	if anim_name == 'end':
		Core.to('main_menu')
		
		GlobalSound.stop_music()
		
		Data.loading()
		Data.loading_settings()
		
		get_tree().paused = false

