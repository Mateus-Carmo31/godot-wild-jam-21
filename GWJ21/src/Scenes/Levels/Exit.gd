extends Area2D

func _ready():
	
	collision_layer = LayerManager.LAYERS.MISC
	collision_mask = LayerManager.LAYERS.PLAYER


