extends Area

signal create_c_red
signal create_c_smile

const c_red_res = preload("res://c_red/c_red.tscn")
const c_smile_res = preload("res://c_smile/c_smile.tscn")

export var character : NodePath

# до активации Data.is_ending
export var is_active = false
# после активации Data.is_good_ending
export var is_secret_active = false

# спавн существа с красными глазами (B1)
export var is_red_spawn = false
# флаг иллюзии B1 (пропадает через некоторое время)
export var is_red_illusion = false
# с улыбкой (B2)
export var is_smile_spawn = false
# активность B2
export var is_smile_active = false
# проверка взятия ложного озарения
export var is_picked_lie_insight_check = false

# начальная анимация B1
export var red_anim_name = ''
export var smile_anim_name = ''
# поворот
export var angle = 0

export(Vector3) var spawn_position

func _ready():
	$mesh.queue_free()
# warning-ignore:return_value_discarded
	connect("create_c_red", self, "_create_c_red")
# warning-ignore:return_value_discarded
	connect("create_c_smile", self, "_create_c_smile")
	
	if is_instance_valid(get_node("./pos")):
		spawn_position = get_node("./pos").global_transform.origin
	
	if Data.is_ending:
		if is_secret_active:
			if Data.is_good_ending:
				is_active = true
			else:
				if is_red_illusion:
					is_active = true
				else:
					is_active = false
		else:
			if Data.is_good_ending:
				if is_picked_lie_insight_check:
					is_active = true
				else:
					if is_red_illusion:
						is_active = true
					else:
						is_active = false
			else:
				if is_smile_spawn && is_smile_active:
					if is_picked_lie_insight_check:
						is_active = false
				else:
					if is_red_illusion:
						is_active = true
					else:
						is_active = false
	else:
		if is_secret_active:
			is_active = false
		elif is_picked_lie_insight_check:
			is_active = false
		elif is_red_illusion:
			is_active = true
	print('is_active: ', is_active)

func _spawn():
	if is_red_spawn:
		emit_signal("create_c_red")
	if is_smile_spawn && !is_smile_active && !Data.is_created_smile:
		emit_signal("create_c_smile")
		print('haggy_non_active')
	elif is_smile_spawn && is_smile_active && !Data.is_created_smile:
		emit_signal("create_c_smile")
		Data.is_created_smile = true

func _create_c_red():
	var c_red = c_red_res.instance()
	c_red.anim = red_anim_name
	c_red.is_illusion = is_red_illusion
	if is_red_illusion:
		c_red.get_node("AnimationPlayer").get_animation('idle').loop = true
	Core.root_level.add_child(c_red)
	c_red.rotation_degrees.y = angle
	c_red.global_transform.origin = spawn_position

func _create_c_smile():
	var c_smile = c_smile_res.instance()
	c_smile.is_active = is_smile_active
	c_smile.anim = smile_anim_name
	Core.root_level.add_child(c_smile)
	c_smile.rotation_degrees.y = angle
	c_smile.global_transform.origin = spawn_position

func _on_creature_trigger_body_entered(body):
	if body.name == 'player' && is_active && !is_picked_lie_insight_check:
		if not character.is_empty() and is_instance_valid(get_node(character)):
			var c = get_node(character) as Spatial
			c.rotation_degrees.y = angle
			c.global_transform.origin = spawn_position
			if c.id == "smile":
				c.is_active = is_smile_active
				c.anim = smile_anim_name
				c.call_deferred("_config")
			else:
				c.anim = red_anim_name
				c.call_deferred("_config")
		else:
			_spawn()
		is_active = false

func _on_creature_trigger_body_exited(body):
	if body.name == 'player' && is_picked_lie_insight_check:
		if Data.is_picked_lie_insight && !Data.is_created_smile:
			_spawn()
			is_active = false
