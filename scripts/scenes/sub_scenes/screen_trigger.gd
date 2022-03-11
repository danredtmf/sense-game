extends Control

# warning-ignore:unused_signal
signal heart(count)

var count = 0
var screen

func _ready():
# warning-ignore:return_value_discarded
	connect("heart", self, "_heart")

func _heartbeating():
	if is_instance_valid(Core.root_menu):
		get_viewport().set_clear_mode(Viewport.CLEAR_MODE_ONLY_NEXT_FRAME)
		yield(get_tree(), "idle_frame")
		screen = Core.root_menu.view_3d.get_texture().get_data()
	else:
		get_viewport().set_clear_mode(Viewport.CLEAR_MODE_ONLY_NEXT_FRAME)
		yield(get_tree(), "idle_frame")
		screen = get_viewport().get_texture().get_data()
	var image = ImageTexture.new()
	image.create_from_image(screen)
	$rect.texture = image
	if !$anim.is_playing():
		$anim.play("scale")

func _heart(int_value: int):
	count = int_value
	
	if count > 0:
		$timer_delay.start()
	else:
		if is_instance_valid(Core.root_menu) && Data.is_ending || Data.is_good_ending:
			$timer_delay_once.wait_time = 0.3
			$timer_delay_once.start()
		elif is_instance_valid(Core.root_menu) && !Data.is_ending || !Data.is_good_ending:
			$timer_delay_once.wait_time = 0.1
			$timer_delay_once.start()
		elif is_instance_valid(Core.root_level):
			$timer_delay_once.wait_time = 0.05
			$timer_delay_once.start()

func _on_anim_animation_finished(_anim_name):
	if count > 0:
		$timer_delay.start()

func _on_timer_delay_timeout():
	count -= 1
	_heartbeating()

func _on_timer_delay_once_timeout():
	_heartbeating()
