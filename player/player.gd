extends KinematicBody

const walk_speed = 400
const run_speed = 600

var speed
var gravity = 300
var camera_sensitivity = Data.saved_mouse_sensitivity

var vel = Vector3.ZERO

onready var camera = $Camera
onready var spotlight = $Camera/SpotLight

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta):
	camera_sensitivity = Data.saved_mouse_sensitivity
	
	camera.rotation_degrees.y = 180
	camera.rotation_degrees.z = 0
	
	var dir = Vector3.ZERO
	vel = Vector3.ZERO
	
	if Input.is_key_pressed(KEY_W):
		dir += transform.basis.z
	elif Input.is_key_pressed(KEY_S):
		dir -= transform.basis.z
	
	if Input.is_key_pressed(KEY_A):
		dir += transform.basis.x
	elif Input.is_key_pressed(KEY_D):
		dir -= transform.basis.x
	
	if Input.is_key_pressed(KEY_SHIFT):
		speed = run_speed
	else:
		speed = walk_speed
	
	if Input.is_action_just_pressed("flashlight_toggle"):
		if spotlight.visible:
			spotlight.visible = !spotlight.visible
		else:
			spotlight.visible = !spotlight.visible
	
	if Input.is_action_just_pressed("interactive"):
		action()
	
	if Input.is_action_just_pressed("pause"):
		if !get_tree().paused && !Core.action_object_viewing && !Core.game_pause:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			get_tree().paused = true
			Core.game_pause = true
	
	vel = dir.normalized() * speed
	
#	if not is_on_floor():
#		vel.y -= gravity
	
	vel = move_and_slide(vel * delta, Vector3.UP)

func _input(event):
	if event is InputEventMouseMotion:
		var movement = event.relative
		camera.rotation.x -= deg2rad(movement.y * camera_sensitivity)
		camera.rotation.x = clamp(camera.rotation.x, deg2rad(-85), deg2rad(85))
		rotation.y += -deg2rad(movement.x * camera_sensitivity)

func action():
	if Core.action_object:
		Core.action_object.call('action')
