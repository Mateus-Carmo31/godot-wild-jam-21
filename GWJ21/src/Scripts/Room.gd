extends Area2D
class_name Room

export(float) var cam_zoom = 1.0

var current_enemies = []
var is_completed : bool = false

onready var checkpoint = $Checkpoint.global_position

func _ready():
	
	collision_layer = LayerManager.LAYERS.MISC
	collision_mask = LayerManager.LAYERS.PLAYER

func _on_Room_body_entered(_body):
	
	Events.emit_signal("wants_cam_focus", $CamPoint.get_path(), cam_zoom)
	
	if is_completed == false:
		Events.emit_signal("player_entered_room", get_path())
		
		Events.connect("enemy_spawned", self, "register_enemy")
		Events.connect("enemy_died", self, "deregister_enemy")
		
		for child in get_children():
			if child is Spawner:
				child.call_deferred("spawn", _body.get_path())

func _on_Room_body_exited(_body):
	Events.emit_signal("released_cam_focus")
	empty_room() # ONLY TEMPORARELY

func register_enemy(enemy):
	current_enemies.push_back(enemy)

func deregister_enemy(enemy):
	
	current_enemies.erase(enemy)
	
	if current_enemies.size() == 0:
		Events.disconnect("enemy_spawned", self, "register_enemy")
		Events.disconnect("enemy_died", self, "deregister_enemy")
		is_completed = true
		print("Room completed!")
	else:
		print(current_enemies.size(), " remaining!")

func empty_room():
	for child in get_children():
		if child is Spawner:
			child.delete_spawned_object()
