extends RigidBody2D
class_name SelectableBody

var is_selected = false

func _ready():
	collision_layer = LayerManager.LAYERS.SELECTABLE_OBJECTS
	collision_mask = LayerManager.get_all_layers([LayerManager.LAYERS.MISC])
	
	$Hitbox.collision_layer = collision_layer
	$Hitbox.collision_mask = (LayerManager.LAYERS.SELECTABLE_OBJECTS |
							  LayerManager.LAYERS.ENEMIES)

func select():
	is_selected = true

func deselect():
	is_selected = false

func pull_towards(dir : Vector2, pull_accel : float):
	pass

func get_speed_projected_on_dir(dir : Vector2):
	pass

func _process(delta):
	update()

func _draw():
	if is_selected:
		draw_circle(global_position - position, 20, Color.yellow)
