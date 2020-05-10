extends KinematicBody2D
class_name KinematicSelectable

export(float, 0, 1000, 10) var speed_to_break = 100.0
export(float, 1, 10, 0.1) var mass = 1

var is_selected = false

var velocity := Vector2()

signal connection_released

func _ready():
	collision_layer = LayerManager.LAYERS.ENEMIES
	collision_mask = LayerManager.get_all_layers([
		LayerManager.LAYERS.CONNECTION_HITBOX,
		LayerManager.LAYERS.MISC
	])
	
	$SelectHitbox.collision_layer = LayerManager.LAYERS.CONNECTION_HITBOX
	$SelectHitbox.collision_mask = LayerManager.LAYERS.CONNECTION_HITBOX

func get_collision_area() -> Area2D:
	return $SelectHitbox as Area2D

func pull_towards(dir : Vector2, pull_accel : float, delta : float):
	velocity += dir * pull_accel * delta * (1.0/mass)
	print(velocity.length())

func get_speed_projected_on_dir(dir : Vector2):
	return velocity.project(dir).length()

func on_collision(knockback_dir : Vector2, collision_speed : float):
	if speed_to_break > 0 and collision_speed >= speed_to_break:
		queue_free()
	else:
		emit_signal("connection_released")

func _physics_process(delta):
	
	velocity = move_and_slide(velocity)
	
	velocity *= pow((10.0-mass)/10, delta * 10.0)

func _process(delta):
	update()

func select():
	is_selected = true

func deselect():
	is_selected = false

func _draw():
	if is_selected:
		draw_circle(global_position - position, 20, Color.yellow)
