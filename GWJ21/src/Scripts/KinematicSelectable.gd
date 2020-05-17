extends KinematicBody2D
class_name KinematicSelectable

export(bool) var unbreakable = false
export(bool) var is_static = false
export(bool) var is_pushable
export(int, 1, 10) var health = 1
export(int, 1, 5) var damage = 1
export(float, 1, 10, 0.1) var mass = 1

var is_selected = false
var is_being_pulled = false

var velocity := Vector2()

# signal connection_released

func _ready():
	collision_layer = LayerManager.LAYERS.OBJECTS
	collision_mask = LayerManager.get_all_layers([
		LayerManager.LAYERS.CONNECTION_HITBOX,
		LayerManager.LAYERS.MISC
	])
	
	$SelectHitbox.collision_layer = LayerManager.LAYERS.CONNECTION_HITBOX
	$SelectHitbox.collision_mask = LayerManager.LAYERS.CONNECTION_HITBOX
	
	if is_static:
		is_pushable = false
	else:
		is_pushable = true

func get_collision_area() -> Area2D:
	return $SelectHitbox as Area2D

func _pull_towards(dir : Vector2, pull_accel : float, delta : float):
	velocity += dir * pull_accel * delta

# Collisions still don't feel right, but for now it will do
# knockback_dir is currently obsolete, maybe remove?
func _on_collision(collided_with : KinematicSelectable):
	
	take_damage(collided_with.damage)
	if not is_static:
		set_deferred("velocity", collided_with.velocity/mass)

func take_damage(damage_taken : int):
	if not unbreakable:
		health = max(health-damage_taken, 0)
		AudioHandler.play_sfx("ObjectDestroy")
	
	if health == 0:
		destroy_self()
		print(name, " died!")

func _physics_process(delta):
	
	if not is_static:
		velocity = move_and_slide(velocity)

	if not is_being_pulled:
		velocity *= pow((10.0-mass)/10, delta * 10.0)
	else:
		velocity *= pow(0.9, delta * 10.0)

func select():
	is_selected = true
	$SelectEffect.activate()

func deselect():
	is_selected = false
	if is_being_pulled:
		is_being_pulled = false
	
	$SelectEffect.deactivate()

func destroy_self():
	queue_free()
