extends Node

var last_step = 0

var current_song = 0
var song_time : float

func _ready():
	randomize()
	Events.connect("player_left", self, "stop_music")
	Events.connect("prompted_restart", self, "stop_music")

func play_sfx(node_path, delay = -1):
	if delay != -1:
		yield(get_tree().create_timer(delay), "timeout")
	
	get_node(node_path).play()

func play_walk_sfx():
	if $Step.playing == false:
		$Step.play()

func start_music(choose_new_song = true):
	
	if choose_new_song:
		current_song = randi() % 2
		get_node(str("Music/Song", current_song)).play()
		song_time = 0.0
	else:
		get_node(str("Music/Song", current_song)).play(song_time)

func stop_music(_player_left = null):
	var song_node : AudioStreamPlayer = get_node(str("Music/Song", current_song))
	song_time = song_node.get_playback_position()
	song_node.stop()
