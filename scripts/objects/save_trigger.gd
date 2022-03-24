extends Area

export var is_active = true
export var is_mesh_visible = true
export var is_consider_end = false

export var is_ending_trigger = false
export var is_good_ending_trigger = false

func _ready():
	_closing_active()
	_active_check()
	_visible_mesh()

func _visible_mesh():
	$mesh.visible = is_mesh_visible

func _closing_active():
	if Data.is_ending && !is_consider_end:
		is_active = false

func _active_check():
	if !is_active:
		queue_free()

func _ending_trigger():
	Data.is_ending = true
	Data.saved_pos_player = Core.root_player.translation
	Data.saving()
	Core.root_gui.saving_progress.emit_signal('showing')
	var saves_group = get_tree().get_nodes_in_group('saves')
	print(saves_group)
	
	for i in saves_group:
		if i.is_ending_trigger:
			i.queue_free()
	
	is_active = false
	print('end')
	_active_check()

func _game_passed():
	print('game passed')
	Data.is_game_passed = true
	Data.saving()
	Core.to('credits')

func _good_ending():
	print('good')
	Data.is_good_ending = true
	Data.saving()
	Core.to('credits')

func _bad_ending():
	print('bad')
	Data.is_picked_lie_insight = true
	Core.to('credits')

func _good_ending_trigger():
	var notes = len(Data.saved_notes)
	var insights = len(Data.saved_insights)
	
	if Data.is_picked_lie_insight == false:
		if insights == 6 && notes == 8:
			_game_passed()
		elif insights == 6:
			_good_ending()
		elif insights != 6:
			_bad_ending()
	else:
		_bad_ending()

func _on_save_trigger_body_entered(body):
	if body.name == "player":
		if is_ending_trigger:
			_ending_trigger()
		elif is_good_ending_trigger:
			_good_ending_trigger()
