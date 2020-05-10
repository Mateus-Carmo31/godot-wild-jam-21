extends RigidBody2D
class_name RigidSelectable

export(float) var speed_to_break = 100.0

var is_selected = false

signal connection_released

func _ready():
	collision_layer = LayerManager.LAYERS.SELECTABLE_OBJECTS
	collision_mask = LayerManager.get_all_layers([
		LayerManager.LAYERS.CONNECTION_HITBOX,
		LayerManager.LAYERS.MISC
	])
	
	$SelectHitbox.collision_layer = LayerManager.LAYERS.CONNECTION_HITBOX
	$SelectHitbox.collision_mask = LayerManager.LAYERS.CONNECTION_HITBOX

func get_collision_area() -> Area2D:
	return $SelectHitbox as Area2D

func pull_towards(dir : Vector2, pull_accel : float, delta : float):
	linear_velocity += dir * pull_accel * delta

func get_speed_projected_on_dir(dir : Vector2):
	return linear_velocity.project(dir).length()

func on_collision(knockback_dir : Vector2, collision_speed : float):
	if collision_speed >= speed_to_break:
		queue_free()
	else:
		linear_velocity = knockback_dir * 20.0 # WIP
		emit_signal("connection_released")

func _process(delta):
	update()

func select():
	is_selected = true

func deselect():
	is_selected = false

func _draw():
	if is_selected:
		draw_circle(global_position - position, 20, Color.yellow)
