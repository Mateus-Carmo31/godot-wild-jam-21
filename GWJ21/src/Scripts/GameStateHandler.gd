extends Node

var last_room : Room
var player : KinematicBody2D

func _ready():
	Events.connect("player_entered_room", self, "set_new_room")
	Events.connect("player_lives_changed", self, "player_death")
	
	player = get_node("Main/EntitySort/Player") as KinematicBody2D

func set_new_room(room_path):
	last_room = (get_node(room_path) as Room)
	print("New room set to ", last_room.name)

func player_death(_lives):
	
#	get_tree().paused = true
#	Events.emit_signal("released_cam_focus")
	
	if _lives > 0:
		pass
	else:
		pass
