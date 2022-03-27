extends MeshInstance

func move():
	get_parent().call('move')

func info():
	get_parent().call('info')
