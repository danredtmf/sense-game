extends Spatial

onready var smile = $c_smile
onready var anim_cam = $anim_cam

func _ready():
	Core.root_jump_map = self
