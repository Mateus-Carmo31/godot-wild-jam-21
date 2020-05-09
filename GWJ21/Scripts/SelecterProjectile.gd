extends Area2D

signal missed
signal hit_something(thing)

var dir : Vector2
const SPEED : float = 400.0

onready var interact_mask = (LayerManager.LAYERS.ENEMIES |
							 LayerManager.LAYERS.SELECTABLE_OBJECTS)

func _ready():
	collision_layer = LayerManager.LAYERS.PLAYER_PROJECTILE
	collision_mask = LayerManager.get_all_layers([LayerManager.LAYERS.PLAYER])

func launch(launch_dir : Vector2):
	dir = launch_dir
	$DestroySelf.start()

func _physics_process(delta):
	
	position += dir * SPEED * delta

func _on_DestroySelf_timeout():
	emit_signal("missed")
	queue_free() # Remove self

func _on_Selector_body_entered(body):
	
	# Checks using a bitmask
	# If the body does not have any bit in common with the mask, then AND == 0
	if body.collision_layer & interact_mask != 0:
		emit_signal("hit_something", body)
	else:
		emit_signal("missed")
	
	queue_free() # WIP: Clean up after self
