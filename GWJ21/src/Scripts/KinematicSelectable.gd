extends KinematicBody2D
class_name KinematicSelectable

export(bool) var unbreakable = false
export(bool) var is_static = false
export(bool) var is_pushable = true
export(int, 1, 10) var health = 1
export(int, 1, 5) var damage = 1
export(float, 1, 10, 0.1) var mass = 1

var is_selected = false
var is_being_pulled = false

var velocity := Vector2()

signal connection_released

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

func get_collision_area() -> Area2D:
	return $SelectHitbox as Area2D

func _pull_towards(dir : Vector2, pull_accel : float, delta : float):
	velocity += dir * pull_accel * delta

# Collisions still don't feel right, but for now it will do
# knockback_dir is currently obsolete, maybe remove?
func _on_collision(collided_with : KinematicSelectable):
	
	take_damage(collided_with.damage)
	set_deferred("velocity", collided_with.velocity/mass)

func take_damage(damage_taken : int):
	if not unbreakable:
		health = max(health-damage_taken, 0)

func _physics_process(delta):
	
	velocity = move_and_slide(velocity)
	
	if not is_being_pulled:
		velocity *= pow((10.0-mass)/10, delta * 10.0)
	else:
		velocity *= pow(0.9, delta * 10.0)

func select():
	is_selected = true

func deselect():
	is_selected = false
	if is_being_pulled:
		is_being_pulled = false

func _process(delta):
	update()
	
	if health == 0:
		queue_free()

func _draw():
	if is_selected:
		draw_circle(global_position - position, 30, Color.yellow)
