extends KinematicBody

export var is_active = false
export var anim = ''

var speed = 700
var non_active_speed = 2000
var vel = Vector3.ZERO

var non_active_run_state_count = 0

var path = []
var path_node = 0

onready var nav : Navigation = Core.root_nav
onready var player = Core.root_player

func _ready():
	if is_active && anim != '':
		$AnimationPlayer.get_animation('run').loop = true
		$AnimationPlayer.play("run")
		$timer_move.start()
	elif !is_active && anim != '':
		$AnimationPlayer.get_animation('run').loop = false
		$AnimationPlayer.playback_speed = 1.5
		$shape.disabled = true
		$AnimationPlayer.play("run")

func _physics_process(delta):
	if is_active && anim != '':
		_active_run(delta)
	elif !is_active && anim != '':
		_non_active_run(delta)

func _active_run(delta):
	if path_node < path.size():
		var direction = path[path_node] - global_transform.origin
		if direction.length() < 1:
			path_node += 1
		else:
			$eyes.look_at(player.global_transform.origin, Vector3.UP)
			rotate_y(deg2rad($eyes.rotation.y * 4))
# warning-ignore:return_value_discarded
			move_and_slide(direction.normalized() * speed * delta, Vector3.UP)

func _move_to(target_pos):
	path = nav.get_simple_path(global_transform.origin, target_pos)
	path_node = 0

func _non_active_run(delta):
	var dir = Vector3.ZERO
	dir -= transform.basis.z
	
	vel = dir.normalized() * non_active_speed
	
	vel = move_and_slide(vel * delta, Vector3.UP)

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == 'run' && \
	$AnimationPlayer.get_animation(anim_name).loop == false:
		if non_active_run_state_count == 2:
			queue_free()
		else:
			non_active_run_state_count += 1
			$AnimationPlayer.play("run")

func _on_VisibilityNotifier_screen_entered():
	if visible:
		if is_instance_valid(Core.root_menu) && !is_active:
			Core.root_menu.menu.heartbeat.emit_signal('heart', 0)
		elif is_instance_valid(Core.root_gui) && !is_active:
			Core.root_gui.heartbeat.emit_signal('heart', 0)
		elif is_instance_valid(Core.root_gui) && is_active:
			Core.root_gui.heartbeat.emit_signal('heart', 100)

func _on_VisibilityNotifier_screen_exited():
	if visible:
		if is_instance_valid(Core.root_gui) && is_active:
			Core.root_gui.heartbeat.emit_signal('heart', 0)

func _on_Area_body_entered(body):
	if body.name == 'player' && visible:
		if is_instance_valid(Core.root_menu) && !is_active:
			Core.root_menu.menu.heartbeat.emit_signal('heart', 0)
		elif is_instance_valid(Core.root_gui) && !is_active:
			Core.root_gui.heartbeat.emit_signal('heart', 0)
		elif is_instance_valid(Core.root_gui) && is_active:
			Core.root_gui.heartbeat.emit_signal('heart', 100)

func _on_Area_body_exited(body):
	if body.name == 'player' && visible:
		if is_instance_valid(Core.root_gui) && is_active:
			Core.root_gui.heartbeat.emit_signal('heart', 0)

func _on_timer_move_timeout():
	_move_to(player.global_transform.origin)