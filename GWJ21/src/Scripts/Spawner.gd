extends Node2D
class_name Spawner

export var object_spawner : bool = false
export var object_name : String

var object_path : NodePath

func _ready():
	pass

func spawn(current_player : NodePath):
	
	var n_entity
	
	if object_spawner:
		n_entity = RESOURCES.objects[object_name].instance()
	else:
		n_entity = RESOURCES.enemies[object_name].instance()
	
	get_parent().get_parent().add_child(n_entity)
	object_path = n_entity.get_path()
	n_entity.global_position = global_position
	
	if not object_spawner:
		n_entity.start_enemy(current_player)
		AudioHandler.play_sfx("EnemyAppears")

func delete_spawned_object():
	if object_path:
		var object = get_node_or_null(object_path)
		if object:
			object.queue_free()
