extends Area2D

var proj_dir : Vector2
var proj_speed : float = 300

var interact_mask = LayerManager.LAYERS.PLAYER

func _ready():
	
	collision_layer = LayerManager.LAYERS.ENEMY_PROJECTILES
	collision_mask = LayerManager.get_all_layers([
		LayerManager.LAYERS.PLAYER_PROJECTILE,
		LayerManager.LAYERS.ENEMIES,
		LayerManager.LAYERS.ENEMY_PROJECTILES,
		LayerManager.LAYERS.CONNECTION_HITBOX,
		LayerManager.LAYERS.MISC
	])

func launch_projectile(dir, speed = -1):
	proj_dir = dir
	
	if speed != -1:
		proj_speed = speed
	
	$DestroySelf.start()

func _physics_process(delta):
	position += proj_dir * proj_speed * delta

func _on_DestroySelf_timeout():
	queue_free() # Clean after self

func _on_Projectile_area_entered(area):
	if area.collision_layer & interact_mask != 0:
		area.get_parent().on_hit(proj_dir)
		queue_free() # Clean after self

func _on_Projectile_body_entered(body):
	if body.collision_layer & interact_mask != 0:
		body.on_hit(proj_dir)
	
	queue_free() # Clean after self
