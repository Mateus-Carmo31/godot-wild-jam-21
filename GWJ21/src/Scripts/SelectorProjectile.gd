extends Area2D

signal missed
signal hit_something(thing)

var dir : Vector2
const SPEED : float = 400.0

onready var interact_mask = LayerManager.LAYERS.CONNECTION_HITBOX

func _ready():
	collision_layer = LayerManager.LAYERS.PLAYER_PROJECTILE
	collision_mask = LayerManager.get_all_layers([
		LayerManager.LAYERS.ENEMY_PROJECTILES,
		LayerManager.LAYERS.PLAYER, 
		LayerManager.LAYERS.MISC
	])

func launch(launch_dir : Vector2):
	dir = launch_dir
	$DestroySelf.start()

func _physics_process(delta):
	position += dir * SPEED * delta

func _on_DestroySelf_timeout():
	emit_signal("missed")
	queue_free() # Remove self

func _on_Selector_area_entered(area):
	
	# Checks using a bitmask
	# If the body does not have any bit in common with the mask, then AND == 0
	if area.collision_layer & interact_mask != 0:
		emit_signal("hit_something", area.get_parent())
	else:
		emit_signal("missed")
	
	queue_free() # WIP: Clean up after self

func _on_Selector_body_entered(body):
	
	# Since nothing that is in the interact_mask is a body,
	# ignore any collisions in this signal
	
	emit_signal("missed")
	queue_free()
