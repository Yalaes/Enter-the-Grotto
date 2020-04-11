extends Node2D

onready var camera = $Player/Camera2D

export var CamLeft: int
export var CamTop: int
export var CamRight: int
export var CamBottom: int

export var CamOffsetH: int
export var CamOffsetV: int

func _ready() -> void:
	camera.limit_left = CamLeft
	camera.limit_top = CamTop
	camera.limit_right = CamRight
	camera.limit_bottom = CamBottom
	camera.offset_h = CamOffsetH
	camera.offset_v = CamOffsetV
