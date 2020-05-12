extends KinematicSelectable
class_name Enemy

export var move_speed : float = 5.0
export var max_speed : float = 100.0
export var current_player : NodePath

var daze : float
export(float, 1, 3, 0.5) var max_daze : float = 0.6
export(float, 0.1, 1, 0.1) var recovery_speed : float = 0.4

func _ready():
	
	collision_layer = LayerManager.LAYERS.ENEMIES
	collision_mask = LayerManager.get_all_layers([
		LayerManager.LAYERS.CONNECTION_HITBOX,
		LayerManager.LAYERS.MISC
	])
	
	$SelectHitbox.collision_layer = LayerManager.LAYERS.CONNECTION_HITBOX
	$SelectHitbox.collision_mask = LayerManager.LAYERS.CONNECTION_HITBOX
	
	is_pushable = false

func add_daze(amount : float):
	self.daze = min(self.daze + amount, self.max_daze)
	print(name, " was dazed! (", self.daze, ")")
