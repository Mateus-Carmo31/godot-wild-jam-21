extends TileMap

func _ready():
	
	collision_layer = LayerManager.LAYERS.WALLS
	collision_mask = LayerManager.get_all_layers([
		LayerManager.LAYERS.CONNECTION_HITBOX,
		LayerManager.LAYERS.MISC
	])
