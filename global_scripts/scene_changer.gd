extends Node

export var max_load_time = 10000

func goto_scene(path):
	var loader = ResourceLoader.load_interactive(path)
	
	if loader == null:
		print('Resource loader unable to load the resource at path')
		return
	
	var loading_bar = load("res://levels/scenes/sub_scenes/progress_bar.tscn").instance()
	
	get_tree().root.call_deferred('add_child', loading_bar)
	
	var t = OS.get_ticks_msec()
	
	while OS.get_ticks_msec() - t < max_load_time:
		var err = loader.poll()
		if err == ERR_FILE_EOF:
			# Loading Complete
			var resource = loader.get_resource()
			Core.root_game.call_deferred('add_child', resource.instance())
			loading_bar.queue_free()
			Core.root_gui.emit_signal('transition_scene', 'start')
			break
		elif err == OK:
			# Still Loading
			var progress = float(loader.get_stage()) / float(loader.get_stage_count())
			loading_bar.get_node('ProgressBar').value = progress * 100
		else:
			print('Error while loading file')
			break
		yield(get_tree(), 'idle_frame')
		yield(get_tree().create_timer(0.15), "timeout")
