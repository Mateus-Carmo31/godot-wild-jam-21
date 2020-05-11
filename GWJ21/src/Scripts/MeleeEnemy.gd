extends Enemy

enum {ATTACK, COOLDOWN, APPROACH, DAZED, SPECIAL}

export(float) var attack_telegraph = 0.6
export(float) var attack_cooldown = 1.0
export(float, 50, 100, 1) var min_attack_dist := 50.0

var state = APPROACH

func _ready():
	._ready()
	
	$AttackPivot/AttackHitbox.collision_layer = LayerManager.LAYERS.MISC
	$AttackPivot/AttackHitbox.collision_mask = LayerManager.LAYERS.PLAYER

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
				pass
	else:
		dazed_state(delta)

func approach_state(delta):
	
	if $StateSwitchTimer.is_connected("timeout", self, "set"):
		$StateSwitchTimer.disconnect("timeout", self, "set")
	
	if current_player:
		var target_dir = global_position.direction_to(get_node(current_player).global_position)
		velocity = lerp(velocity, target_dir * max_speed, move_speed * delta)
	
	velocity = move_and_slide(velocity)
	
	if is_being_pulled:
		velocity *= pow((10-mass)/10, delta * 10)
	else:
		velocity *= pow(0.9, delta * 10)
	
	if current_player:
		var dist = global_position.distance_to(get_node(current_player).global_position)
		if dist < min_attack_dist:
			print("Reached!")
			velocity = Vector2.ZERO
			state = ATTACK
			$StateSwitchTimer.start(attack_telegraph)
			$StateSwitchTimer.connect("timeout", self, "attack")

func attack_state(delta):
	if current_player:
		$AttackPivot.look_at(get_node(current_player).global_position)

func attack():
	$StateSwitchTimer.disconnect("timeout", self, "attack")
	var bodies = $AttackPivot/AttackHitbox.get_overlapping_bodies()
	
	if bodies.has(get_node(current_player)):
		print("Hit!")
	
	state = COOLDOWN
	$StateSwitchTimer.connect("timeout", self, "set", ["state", APPROACH])
	$StateSwitchTimer.start(attack_cooldown)

func select():
	.select()
	add_daze(max_daze)

func take_damage(damage_taken : int):
	.take_damage(damage_taken)
	add_daze(max_daze)

func dazed_state(delta):
	
	daze = max(daze - recovery_speed * delta, 0)
	
	if daze == 0:
		print(name, "'s not dazed anymore!")
		state = APPROACH
