extends Spatial

signal create_note
signal create_insight
signal create_lie_insight

const book_res = preload("res://levels/objects/book.tscn")
const note_res = preload("res://levels/objects/note.tscn")
const insight_res = preload("res://levels/objects/insight.tscn")
const lie_insight_res = preload("res://levels/objects/lie_insight.tscn")

const lie_insight_mat_res = preload("res://levels/models/materials/lie_insight.material")

export var is_lamp_flashing = false

export var id_note = 0
export var is_note_exist = false
export var is_note_secret = false

export var id_insight = 0
export var is_insight_exist = false
export var is_lie_insight = false

func _ready():
# warning-ignore:return_value_discarded
	connect("create_note", self, "_on_create_note")
# warning-ignore:return_value_discarded
	connect("create_insight", self, "_on_create_insight")
# warning-ignore:return_value_discarded
	connect("create_lie_insight", self, "_on_create_lie_insight")
	
	if is_note_exist && id_note != 0:
		emit_signal("create_note")
	if is_insight_exist && id_insight != 0:
		emit_signal("create_insight")
	elif is_insight_exist && is_lie_insight:
		emit_signal("create_lie_insight")
	if is_lamp_flashing:
		$Timer.start()

func _on_create_note():
	var note = note_res.instance()
	note.get_node("action").id = id_note
	if is_note_secret:
		var book = book_res.instance()
		$pos_book.add_child(book)
		if Data.is_good_ending:
			book.pos_note.add_child(note)
	else:
		$pos_note.add_child(note)

func _on_create_insight():
	var insight = insight_res.instance()
	insight.get_node("action").id = id_insight
	$pos_insight.add_child(insight)

func _on_create_lie_insight():
	var lie_insight = lie_insight_res.instance()
	lie_insight.set_surface_material(0, lie_insight_mat_res)
	$pos_insight.add_child(lie_insight)

func _on_lamp_light():
	$lamp.is_on = !$lamp.is_on
	$lamp.call('light')

# warning-ignore:unused_argument
func _on_anim_animation_finished(anim_name):
	if is_lamp_flashing:
		$Timer.start()

func _on_Timer_timeout():
	if !$anim.is_playing():
		$anim.play("flashing_light")
