extends KinematicBody

export var is_active = false
export var anim = ''

var speed
var speed_min = 750
var speed_max = 1500
var non_active_speed = 2000
var vel = Vector3.ZERO

var non_active_run_state_count = 0

var path = []
var path_node = 0

onready var nav : Navigation = Core.root_nav
onready var player = Core.root_player

func _ready():
	if !is_active && anim == 'attack':
		return
	if is_active && anim != '':
		$AnimationPlayer.get_animation('run').loop = true
		$AnimationPlayer.play("run")
		$timer_move.start()
		if Data.is_picked_lie_insight:
			GlobalSound.play_music('smile')
		else:
			GlobalSound.play_music('smile_full')
		$step_anim.play("step")
	elif !is_active && anim != '':
		$AnimationPlayer.get_animation('run').loop = false
		$AnimationPlayer.playback_speed = 1.5
		$shape.disabled = true
		$AnimationPlayer.play("run")
		GlobalSound.play_sound('smile_jump')
		$step_anim.play("step")

func start_attack():
	if !is_active && anim == 'attack':
		$AnimationPlayer.playback_speed = 1.5
		$AnimationPlayer.play(anim)
		$timer_jump_anim_delay.start()

func _physics_process(delta):
	if !is_active && anim == 'attack':
		set_physics_process(false)
	elif is_active && anim != '':
		_active_run(delta)
	elif !is_active && anim != '':
		_non_active_run(delta)

func _active_run(delta):
	if path_node < path.size():
		var direction = path[path_node] - global_transform.origin
		if direction.length() < 1:
			path_node += 1
		else:
			direction.y = 0
			var look_at_point = translation + direction.normalized()
			
			$eyes.look_at(look_at_point, Vector3.UP)
			rotate_y(deg2rad($eyes.rotation.y * 4))
			
			var distance_to_player = \
				global_transform.origin.distance_to(path[-1])
			
			if distance_to_player > 10:
				speed = speed_max
				$AnimationPlayer.playback_speed = 2
				$step_anim.playback_speed = 2
			else:
				speed = speed_min
				$AnimationPlayer.playback_speed = 1
				$step_anim.playback_speed = 1
			
# warning-ignore:return_value_discarded
			move_and_slide(direction.normalized() \
			* speed * delta, Vector3.UP)

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
			Core.root_menu.heartbeat.emit_signal('heart', 0)
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
			Core.root_menu.heartbeat.emit_signal('heart', 0)
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

func _on_area_catcher_body_entered(body):
	if body.name == 'player' && is_active:
		GlobalSound.stop_music()
		Core.to('game_over')

func _on_timer_jump_anim_delay_timeout():
	if is_instance_valid(Core.root_jump_map):
		Core.root_jump_map.anim_cam.play('start')
