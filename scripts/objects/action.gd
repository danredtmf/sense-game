extends Area

var action_name = ''
export var action_id = ''
export var id = 0
var action_pickup = false
var action_viewing = false

var delete_parent = false
var delete_action = false
export var parent_function = ''

func _ready():
	$mesh.queue_free()
	if action_id == 'note' && id != 0:
		action_name = tr('note_'+str(id))
		action_pickup = true
		action_viewing = true
		delete_parent = false
		delete_action = false
		if id in Data.saved_notes:
			action_pickup = false
			action_viewing = true
			delete_parent = false
			delete_action = false
	elif action_id == 'insight' && id != 0:
		action_name = tr(action_id)
		action_pickup = true
		action_viewing = false
		delete_parent = true
		delete_action = false
		if id in Data.saved_insights:
			action_pickup = false
			action()
	elif action_id == 'lie_insight':
		action_name = tr('insight')
		action_pickup = true
		action_viewing = false
		delete_parent = true
		delete_action = false
	elif action_id == 'book':
		action_name = 'Book'
		action_pickup = false
		action_viewing = false
		delete_parent = false
		delete_action = false
		if !Data.is_good_ending:
			parent_function = 'info'

func _process(_delta):
	if action_id == 'note' && id != 0:
		action_name = tr('note_'+str(id))
	elif action_id == 'insight' && id != 0:
		action_name = tr(action_id)
	elif action_id == 'lie_insight':
		action_name = tr('insight')
	elif action_id == 'book':
		action_name = tr('book')

func action():
	if action_id && action_pickup && !parent_function:
		if action_id == 'note':
			Data.packing(action_id, id)
			action_pickup = false
			Core.root_gui.inventory.emit_signal('showing')
		elif action_id == 'insight':
			Data.packing(action_id, id)
			Core.root_gui.inventory.emit_signal('showing')
		elif action_id == 'lie_insight':
			Data.is_picked_lie_insight = true
	
	if action_id && action_viewing:
		Core.action_object_viewing = true
	
	if parent_function:
		get_parent().call(parent_function)
	
	if delete_parent:
		get_parent().call_deferred('free')
	elif delete_action:
		call_deferred('free')
