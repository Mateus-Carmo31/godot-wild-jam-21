extends KinematicSelectable
class_name Enemy

export var move_speed : float = 5.0
export var max_speed : float = 100.0
export var current_player : NodePath

var daze : float
export(float, 0.2, 2, 0.1) var max_daze : float = 0.6

func _ready():
	
	collision_layer = LayerManager.LAYERS.ENEMIES
	collision_mask = LayerManager.get_all_layers([
		LayerManager.LAYERS.ENEMY_PROJECTILES,
		LayerManager.LAYERS.CONNECTION_HITBOX,
		LayerManager.LAYERS.MISC
	])
	
	$SelectHitbox.collision_layer = LayerManager.LAYERS.CONNECTION_HITBOX
	$SelectHitbox.collision_mask = LayerManager.LAYERS.CONNECTION_HITBOX
	
	is_pushable = false

func add_daze(amount : float):
	self.daze = min(self.daze + amount, self.max_daze)
	print(name, " was dazed! (", self.daze, ")")

func select():
	.select()
	add_daze(max_daze)

func take_damage(damage_taken : int):
	.take_damage(damage_taken)
	add_daze(max_daze)

func start_enemy(player : NodePath):
	Events.emit_signal("enemy_spawned", self)
	current_player = player

func destroy_self():
	Events.emit_signal("enemy_died", self)
	queue_free()
