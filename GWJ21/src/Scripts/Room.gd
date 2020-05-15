extends Area2D
class_name Room

export(float) var cam_zoom = 1.0
export(Array, NodePath) var blockades = []
export(bool) var is_completed : bool = false

var current_enemies = []

onready var checkpoint = $Checkpoint.global_position

func _ready():
	
	add_to_group("rooms")
	
	collision_layer = LayerManager.LAYERS.MISC
	collision_mask = LayerManager.LAYERS.PLAYER
	
	if blockades.size() == 0:
		is_completed = true

func _on_Room_body_entered(_body):
	
	print(_body.name)
	
	Events.emit_signal("wants_cam_focus", $CamPoint.get_path(), cam_zoom)
	
	if is_completed == false:
		
		Events.connect("enemy_spawned", self, "register_enemy")
		Events.connect("enemy_died", self, "deregister_enemy")
		
		Events.emit_signal("player_entered_room", get_path())
		
		_body.clear_selections_and_connections()
		
		for child in get_children():
			if child is Spawner:
				child.call_deferred("spawn", _body.get_path())
		
		lock_doors(0.5)

func _on_Room_body_exited(_body):
	Events.emit_signal("released_cam_focus")
	
	if not is_completed:
		empty_room(0.5)

func register_enemy(enemy):
	current_enemies.push_back(enemy)

func deregister_enemy(enemy):
	
	current_enemies.erase(enemy)
	
	if current_enemies.size() == 0:
		complete_room()
	else:
		print(current_enemies.size(), " remaining!")

func complete_room():
	Events.disconnect("enemy_spawned", self, "register_enemy")
	Events.disconnect("enemy_died", self, "deregister_enemy")
	is_completed = true
	
	unlock_doors()
	
	Events.emit_signal("room_cleared")
	
	print("Room completed!")

func empty_room(unlock_wait = -1):
	
	if Events.is_connected("enemy_spawned", self, "register_enemy"):
		Events.disconnect("enemy_spawned", self, "register_enemy")
	if Events.is_connected("enemy_died", self, "deregister_enemy"):
		Events.disconnect("enemy_died", self, "deregister_enemy")
	
	for child in get_children():
		if child is Spawner:
			child.delete_spawned_object()
	
	current_enemies.clear()
	
	unlock_doors(unlock_wait)

func lock_doors(wait = -1):
	if wait != -1:
		yield(get_tree().create_timer(wait), "timeout")
	
	for blockade in blockades:
		get_node(blockade).lock()

func unlock_doors(wait = -1):
	if wait != -1:
		yield(get_tree().create_timer(wait), "timeout")
	
	for blockade in blockades:
		get_node(blockade).unlock()
