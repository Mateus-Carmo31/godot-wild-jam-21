extends Node

export(int) var level_id

var can_pause = false
var game_paused = false

var last_room : Room
var player : KinematicBody2D
var exit : Area2D

onready var ui_manager = $UI/UI_Control

func _ready():
	
	level_id = GameHandler.last_level_id
	
	Events.connect("player_entered_room", self, "set_new_room")
	Events.connect("player_lives_changed", self, "player_death")
	Events.connect("room_cleared", self, "check_for_level_completed", [], CONNECT_DEFERRED)
	Events.connect("player_left", self, "leave_level")
	Events.connect("prompted_restart", self, "restart_level")
	
	player = get_node("Main/EntitySort/Player") as KinematicBody2D
	exit = get_node("Main/Exit") as Area2D
	
	yield(get_tree().create_timer(0.5), "timeout")
	ui_manager.unwipe(true)
	yield(ui_manager.anim_player, "animation_finished")
	can_pause = true
	
	AudioHandler.start_music()

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
	AudioHandler.stop_music()
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
		AudioHandler.start_music(false)
	else:
		disconnect_rooms()
		AudioHandler.stop_music()
		GameHandler.return_to_map(false)
	
	can_pause = true

func check_for_level_completed():
	
	print(get_tree().get_nodes_in_group("rooms"))
	
	var level_completed = true
	for room in get_tree().get_nodes_in_group("rooms"):
		if (room as Room).is_completed == false:
			level_completed = false
			break
	
	if level_completed:
		exit.set_active()
		AudioHandler.stop_music()
		print("Level completed!")
	else:
		print("Level not yet completed!")

func pause_unpause():
	if can_pause:
		if get_tree().paused == false:
			ui_manager.pause_screen()
			AudioHandler.stop_music()
			get_tree().paused = true
			print("Paused Game!")
		else:
			ui_manager.unpause_screen()
			AudioHandler.start_music(false)
			get_tree().paused = false
			print("Unpaused Game!")

func leave_level(left_through_exit):
	
	can_pause = false
	ui_manager.wipe()
	yield(ui_manager.anim_player, "animation_finished")
	get_tree().paused = false
	disconnect_rooms()
	
	if left_through_exit:
		GameHandler.return_to_map(true)
		print("Transition! Level was completed!")
	else:
		GameHandler.return_to_map(false)
		print("Transition! Level was not completed!")

func restart_level():
	
	can_pause = false
	ui_manager.wipe()
	yield(ui_manager.anim_player, "animation_finished")
	get_tree().paused = false
	disconnect_rooms()
	
	GameHandler.change_to_level(level_id)

# Rooms are bugging when changing levels, so this is a quick fix.
# Player is registering as having "left" the room during scene change,
# ask about this later in the discord.
func disconnect_rooms():
	for room in get_tree().get_nodes_in_group("rooms"):
		if room.is_connected("body_exited", room, "_on_Room_body_exited"):
			room.disconnect("body_exited", room, "_on_Room_body_exited")
