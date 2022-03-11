extends Spatial

const c_red_res = preload("res://c_red/c_red.tscn")
const c_smile_res = preload("res://c_smile/c_smile.tscn")

var chance = 3

var c_red
var c_smile

func _ready():
	var chance_var = randi() % chance + 1
	if Data.is_ending:
		if !Data.is_main_menu_jampscare_done && Data.is_good_ending:
			create_smile_jump()
			create_red()
			Data.is_main_menu_jampscare_done = true
			Data.saving()
		else:
			if chance_var == chance:
				create_smile_jump()
				create_red()
			else:
				create_smile()
				create_red()
	else:
		create_smile()
		create_red()

func create_smile_jump():
	c_smile = c_smile_res.instance()
	c_smile.anim = 'run'
	add_child(c_smile)
	c_smile.global_transform.origin = $smile_jump_pos.global_transform.origin
	c_smile.rotation_degrees.y = $smile_jump_pos.rotation_degrees.y

func create_smile():
	c_smile = c_smile_res.instance()
	add_child(c_smile)
	c_smile.global_transform.origin = $smile_pos.global_transform.origin
	c_smile.rotation_degrees.y = $smile_pos.rotation_degrees.y
	c_smile.visible = false
	$timer_smile.start()

func create_red():
	c_red = c_red_res.instance()
	c_red.anim = 'idle'
	c_red.get_node("AnimationPlayer").get_animation('idle').loop = true
	add_child(c_red)
	c_red.rotation_degrees.y = $red_pos.rotation_degrees.y
	c_red.global_transform.origin = $red_pos.global_transform.origin
	c_red.visible = false
	$timer_red.start()

func _on_timer_red_timeout():
	var _chance = randi() % 5 + 0
	
	match _chance:
		3:
			if c_red.visible:
				c_red.visible = false
			else:
				c_red.visible = true
		2:
			c_red.visible = false

func _on_timer_smile_timeout():
	var _chance = randi() % 5 + 0
	
	match _chance:
		1:
			if c_smile.visible:
				c_smile.visible = false
			else:
				c_smile.visible = true
				Core.root_menu.menu.heartbeat.emit_signal('heart', 0)
		4:
			c_smile.visible = false
		2:
			c_smile.visible = false
