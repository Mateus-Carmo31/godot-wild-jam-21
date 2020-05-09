extends RigidBody2D

func _ready():
	
	collision_layer = LayerManager.LAYERS.OBJECTS
	collision_mask = LayerManager.get_all_layers()
	pass
