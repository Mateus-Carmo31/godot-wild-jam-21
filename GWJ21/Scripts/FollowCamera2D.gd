extends Camera2D

export var decay = 0.6 # Speed at which the shake slows down
export var max_angle = 0.1
export var max_offset = Vector2(100, 75)
export(NodePath) var target
export var follow_factor = 0.5

export var trauma = 0.0

func _ready():
	randomize()
	
	Events.connect("screen_shake", self, "add_trauma")

func _process(delta):
	if target:
		global_position += (get_node(target).global_position - global_position) * follow_factor * delta * 10
	
	if trauma:
		trauma = max(trauma - decay * delta, 0)
		shake()

func add_trauma(amount : float):
	trauma = min(trauma + amount, 1)

func shake():
	var amount = trauma * trauma
	rotation = max_angle * amount * rand_range(-1, 1)
	offset.x = max_offset.x * amount * rand_range(-1, 1)
	offset.y = max_offset.y * amount * rand_range(-1, 1)
