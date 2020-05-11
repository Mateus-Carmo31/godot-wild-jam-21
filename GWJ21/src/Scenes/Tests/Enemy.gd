extends KinematicSelectable

var move_speed : float = 5.0
var max_speed : float = 100.0
export var current_player : NodePath

var daze_amount : float

func _ready():
	
	collision_layer = LayerManager.LAYERS.ENEMIES
	collision_mask = LayerManager.get_all_layers([
		LayerManager.LAYERS.CONNECTION_HITBOX,
		LayerManager.LAYERS.MISC
	])
	
	$SelectHitbox.collision_layer = LayerManager.LAYERS.CONNECTION_HITBOX
	$SelectHitbox.collision_mask = LayerManager.LAYERS.CONNECTION_HITBOX

func _on_collision(collided_with : KinematicSelectable):
	._on_collision(collided_with)

func _pull_towards(dir : Vector2, pull_accel : float, delta : float):
	velocity += dir * pull_accel * delta

func _physics_process(delta):
	
	if current_player:
		var travel_dir = global_position.direction_to(get_node(current_player).global_position)
		velocity = lerp(velocity, travel_dir * max_speed, move_speed * delta)
	
	velocity = move_and_slide(velocity)
	
	velocity *= pow((10.0-mass)/10, delta * 10.0)
