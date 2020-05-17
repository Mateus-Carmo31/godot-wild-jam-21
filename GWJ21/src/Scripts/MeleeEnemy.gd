extends Enemy

enum {ATTACK, COOLDOWN, APPROACH, SPECIAL}
enum AttackMode {SLASH, STAB}

export(AttackMode) var attack_mode
export(float) var attack_telegraph = 0.6
export(float) var attack_cooldown = 1.0
export(float, 50, 110, 1) var min_attack_dist := 50.0

var state = APPROACH
var hitbox_on : bool = false

var current_facing = true # LEFT => TRUE | RIGHT => FALSE
onready var weapon_holding_slot_L = $Weapon.position
onready var weapon_holding_slot_R = Vector2(-weapon_holding_slot_L.x, $Weapon.position.y)

func _ready():
	._ready()
	
	$Weapon/AttackHitbox.collision_layer = LayerManager.LAYERS.MISC
	$Weapon/AttackHitbox.collision_mask = LayerManager.LAYERS.PLAYER
	$Weapon/AttackHitbox.connect("body_entered", self, "_on_hitbox_entered")

func _on_collision(collided_with : KinematicSelectable):
	._on_collision(collided_with)

func _pull_towards(pull_dir : Vector2, pull_accel : float, delta : float):
	._pull_towards(pull_dir, pull_accel, delta)

func _physics_process(delta):
	
	if not daze:
		match(state):
			APPROACH:
				approach_state(delta)
			ATTACK:
				attack_state(delta)
			COOLDOWN:
				cooldown_state(delta)
	else:
		dazed_state(delta)

func approach_state(delta):
	
	if $StateSwitchTimer.is_connected("timeout", self, "set"):
		$StateSwitchTimer.disconnect("timeout", self, "set")
	
	if current_player:
		var target_dir = global_position.direction_to(get_node(current_player).global_position)
		velocity = lerp(velocity, target_dir * max_speed, move_speed * delta)
		
		current_facing = velocity.x < 0
		update_facing(delta)
		$Weapon.rotation = 0
	
	if current_player:
		var dist = global_position.distance_to(get_node(current_player).global_position)
		if dist < min_attack_dist:
			print("Reached!")
			velocity = Vector2.ZERO
			state = ATTACK
			if attack_mode == AttackMode.SLASH:
				$StateSwitchTimer.connect("timeout", self, "slash_attack")
			elif attack_mode == AttackMode.STAB:
				$StateSwitchTimer.connect("timeout", self, "stab_attack")
			
			$StateSwitchTimer.start(attack_telegraph)

func attack_state(delta):
	if current_player:
		$AttackPivot.look_at(get_node(current_player).global_position)
		
		if attack_mode == AttackMode.SLASH:
			$Weapon.position = lerp($Weapon.position, $AttackPivot.position, delta * 5.0)
			
			if current_facing == true:
				$Weapon.rotation = lerp_angle($Weapon.rotation, $AttackPivot.rotation+deg2rad(180.0), delta * 5.0)
			else:
				$Weapon.rotation = lerp_angle($Weapon.rotation, $AttackPivot.rotation, delta * 5.0)
		else:
			var forward_dir = Vector2(cos($AttackPivot.rotation), sin($AttackPivot.rotation))
			$Weapon.position = lerp($Weapon.position, $AttackPivot.position - forward_dir * 30.0, delta*5.0)
			$Weapon.rotation = lerp_angle($Weapon.rotation, $AttackPivot.rotation+deg2rad(90.0), delta * 5.0)


func slash_attack():
	
	$StateSwitchTimer.disconnect("timeout", self, "slash_attack")
	AudioHandler.play_sfx("EnemyMelee")
	
	hitbox_on = true
	if current_facing == true:
		$Tween.interpolate_property($Weapon, "rotation",
									$Weapon.rotation,
									$Weapon.rotation-deg2rad(180),
									0.1, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	else:
		$Tween.interpolate_property($Weapon, "rotation",
									$Weapon.rotation,
									$Weapon.rotation+deg2rad(180),
									0.1, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	
	$Tween.start()
	print("Attack!")

func stab_attack():
	
	$StateSwitchTimer.disconnect("timeout", self, "stab_attack")
	AudioHandler.play_sfx("EnemyMelee")
	
	var forward_dir = Vector2(cos($AttackPivot.rotation), sin($AttackPivot.rotation))
	
	hitbox_on = true
	
	$Tween.interpolate_property($Weapon, "position",
								$Weapon.position,
								$AttackPivot.position + forward_dir*10.0,
								0.1, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	
	$Tween.start()
	print("Attack!")

func end_attack():
	hitbox_on = false
	state = COOLDOWN
	$StateSwitchTimer.connect("timeout", self, "set", ["state", APPROACH])
	$StateSwitchTimer.start(attack_cooldown)

func cooldown_state(delta):
	$Weapon.rotation = lerp($Weapon.rotation, 0, delta * 5)
	update_facing(delta)

func dazed_state(delta):
	
	if current_facing == true:
		$Weapon.rotation = lerp($Weapon.rotation, deg2rad(15), delta * 5)
	else:
		$Weapon.rotation = lerp($Weapon.rotation, deg2rad(-15), delta * 5)
	
	if not is_selected:
		daze = max(daze - delta, 0)
	
	if daze == 0:
		print(name, "'s not dazed anymore!")
		state = APPROACH

func update_facing(delta):
	if current_facing == true:
		$Sprite.flip_h = false
		$Weapon.position = lerp($Weapon.position, weapon_holding_slot_L, delta * 5)
	else:
		$Sprite.flip_h = true
		$Weapon.position = lerp($Weapon.position, weapon_holding_slot_R, delta * 5)

func _on_hitbox_entered(body):
	if hitbox_on:
		print("Hit ", body.name)
		
		var dir = Vector2(cos($AttackPivot.rotation), sin($AttackPivot.rotation))
		body.on_hit(dir)
