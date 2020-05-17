extends Enemy

enum {CHARGING, COOLDOWN}

export(float) var min_dist = 200.0
export(float) var charge_time = 1.0
export(float) var fire_rate = 1.0

var ProjectileScene = preload("res://src/Scenes/Projectiles/FireProjectile.tscn")
var state = CHARGING
var can_fire = true

func _on_collision(collided_with : KinematicSelectable):
	._on_collision(collided_with)

func _pull_towards(pull_dir : Vector2, pull_accel : float, delta : float):
	._pull_towards(pull_dir, pull_accel, delta)

func _physics_process(delta):
	if current_player:
		
		if not daze:
			adjust_dist(delta)
		else:
			dazed_state(delta)

func adjust_dist(delta):
	var dist = global_position.distance_to(get_node(current_player).global_position)
	
	var move_dir = global_position.direction_to(get_node(current_player).global_position)
	
	if not is_static:
		if dist < min_dist - 10.0: # Get away
			velocity = lerp(velocity, -move_dir * max_speed, delta * move_speed)
		elif dist > min_dist + 10.0: # Approach
			velocity = lerp(velocity, move_dir * max_speed, delta * move_speed)
	
	if can_fire:
		call_deferred("charge_projectile")
		can_fire = false
	
	$Sprite.flip_h = move_dir.x > 0

func dazed_state(delta):
	
	if not is_selected:
		daze = max(daze - delta, 0)
	
	if daze == 0:
		print(name, "'s not dazed anymore!")
		state = CHARGING

func charge_projectile():
	state = CHARGING
	print("Charging!")
	
	$Tween.interpolate_property($Sprite, "scale", 
								$Sprite.scale, $Sprite.scale + Vector2(-0.3, 0.5),
								charge_time, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	
	if charge_time >= 0.54:
		AudioHandler.play_sfx("EnemyCharge")
	
	$Tween.start()

func _on_tween_completed(object, key):
	if object == $Sprite and key == ":scale" and state == CHARGING:
		print("SHOOT!")
		
		AudioHandler.play_sfx("EnemyShoot")
		
		var proj = ProjectileScene.instance()
		var launch_dir = global_position.direction_to(get_node(current_player).global_position)
		get_parent().add_child(proj)
		proj.position = position
		proj.launch_projectile(launch_dir)
		
		state = COOLDOWN
		$Tween.interpolate_property($Sprite, "scale",
									$Sprite.scale, $Sprite.scale - Vector2(-0.3, 0.5),
									0.05, Tween.TRANS_CUBIC, Tween.EASE_OUT)
		
		$Tween.start()
		get_tree().create_timer(fire_rate).connect("timeout", self, "_on_cooldown_end")

func _on_cooldown_end():
	state = CHARGING
	can_fire = true
