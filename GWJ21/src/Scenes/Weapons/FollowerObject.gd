extends Node2D

const FOLLOW_FACTOR = 6

var target : NodePath
var offset_dir := Vector2.ZERO
var offset := 0.0

func _physics_process(delta):
	
	if target:
		global_position = lerp(global_position, 
							   get_node(target).global_position + offset_dir * offset,
							   delta * FOLLOW_FACTOR)

func set_offset(_offset_dir, _offset):
	offset_dir = _offset_dir
	offset = _offset
