extends Node

enum LAYERS {
	PLAYER = 0,
	PLAYER_PROJECTILE,
	ENEMIES,
	ENEMY_PROJECTILES,
	SELECTABLE_OBJECTS,
	OBJECTS,
	WALLS,
	MISC
}

func _ready():
	var i : int = 0
	for layer in LAYERS.keys():
		LAYERS[layer] = int(pow(2, i)) # Sets each layer to a bit
		ProjectSettings.set_setting(str("layer_names/2d_physics/layer_", i+1), layer)
		i += 1

func get_all_layers(ignore_layers = [], include_misc = false):
	
	var bits : int = 0
	for layer in LAYERS.values():
		bits |= layer
	
	for layer in ignore_layers:
		bits &= ~layer # Removes the layer with a bit of bitwise magic
	
	return bits
