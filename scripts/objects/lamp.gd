extends MeshInstance

# warning-ignore:unused_signal
signal light

export var is_on = true

func _ready():
	light()

func light():
	$SpotLight.visible = is_on
