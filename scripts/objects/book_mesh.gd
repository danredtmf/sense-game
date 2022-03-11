extends MeshInstance

func move():
	get_parent().call('move')
