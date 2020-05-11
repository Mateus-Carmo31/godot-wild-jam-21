extends Camera2D

export var decay = 0.6 # Speed at which the shake slows down
export var max_angle = 0.1
export var max_offset = Vector2(100, 75)

export var trauma = 0.0

export var follow_factor = 0.5
export(NodePath) var player
var target : NodePath
var current_zoom : float = 1.0
var target_zoom : float = 1.0

func _ready():
	randomize()
	
	if player:
		target = player
	
	Events.connect("screen_shake", self, "add_trauma")
	Events.connect("wants_cam_focus", self, "focus_on")
	Events.connect("released_cam_focus", self, "focus_on", [player, 1.0])

func _physics_process(delta):
	if target:
		global_position = lerp(global_position, get_node(target).global_position, follow_factor)
		if global_position.distance_to(get_node(target).global_position) <= 1.5:
			global_position = get_node(target).global_position
		
		if current_zoom != target_zoom:
			current_zoom = lerp(current_zoom, target_zoom, follow_factor)
		
		zoom = Vector2.ONE * current_zoom
	
	if trauma:
		trauma = max(trauma - decay * delta, 0)
		shake()
	
	if Input.is_key_pressed(KEY_Q):
		zoom = Vector2.ONE * 0.5
	elif Input.is_key_pressed(KEY_E):
		zoom = Vector2.ONE * 2.0

func add_trauma(amount : float):
	print("Applied ", amount, " to trauma!")
	trauma = min(trauma + amount, 1)

func shake():
	var amount = trauma * trauma
	rotation = max_angle * amount * rand_range(-1, 1)
	offset.x = max_offset.x * amount * rand_range(-1, 1)
	offset.y = max_offset.y * amount * rand_range(-1, 1)

func focus_on(node_path, camera_zoom):
	if node_path:
		target = node_path
		target_zoom = camera_zoom
