extends Node

var can_pause = true
var game_paused = false

var last_room : Room
var player : KinematicBody2D

onready var ui_manager = $UI/UI_Control

func _ready():
	Events.connect("player_entered_room", self, "set_new_room")
	Events.connect("player_lives_changed", self, "player_death")
	Events.connect("room_cleared", self, "check_for_level_completed", [], CONNECT_DEFERRED)
	
	player = get_node("Main/EntitySort/Player") as KinematicBody2D

func set_new_room(room_path):
	last_room = (get_node(room_path) as Room)
	print("New room set to ", last_room.name)

func _process(delta):
	
	if Input.is_action_just_pressed("pause") and can_pause:
		pause_unpause()

func player_death(_lives):
	
	OS.delay_msec(100)
	
	can_pause = false
	get_tree().paused = true
	Events.emit_signal("released_cam_focus")
	
	yield(get_tree().create_timer(0.6), "timeout")
	
	ui_manager.death_animations()
	yield(ui_manager.anim_player, "animation_finished")
	
	last_room.empty_room()
	player.global_position = last_room.checkpoint
	
	yield(Events, "death_animation_ended")
	
	get_tree().paused = false
	
	if _lives > 0:
		ui_manager.unwipe()
		yield(ui_manager.anim_player, "animation_finished")
	else:
		pass
	
	can_pause = true

func check_for_level_completed():
	
	var level_completed = true
	for room in get_tree().get_nodes_in_group("rooms"):
		level_completed = (room as Room).is_completed
	
	if level_completed:
		print("Level completed!")
	else:
		print("Level not yet completed!")

func pause_unpause():
	if can_pause:
		if get_tree().paused == false:
			ui_manager.pause_screen()
			get_tree().paused = true
			print("Paused Game!")
		else:
			ui_manager.unpause_screen()
			get_tree().paused = false
			print("Unpaused Game!")
			
