extends RigidBody2D

const SELECTOR : PackedScene = preload("res://Scenes/Projectile.tscn")

const ACCEL = 10
const MAX_SPEED = 200
const TURN_DAMP = 0.65
const STOP_DAMP = 0.8
const DAZED_DAMP = 0.2

var dazed : bool = false # WIP

func _ready():
	collision_layer = LayerManager.LAYERS.PLAYER
	collision_mask = (
		LayerManager.LAYERS.ENEMIES | 
		LayerManager.LAYERS.ENEMY_PROJECTILES | 
		LayerManager.LAYERS.OBJECTS |
		LayerManager.LAYERS.WALLS
	)

func _physics_process(delta):
	
	var input = get_player_input()
	
	if input != Vector2.ZERO and not dazed:
		linear_velocity += input * ACCEL
		linear_velocity = linear_velocity.clamped(MAX_SPEED)
		
		if input.dot(linear_velocity.normalized()) < -0.5:
			linear_velocity *= pow(1.0-TURN_DAMP, delta * 10)
	else:
		if not dazed:
			linear_velocity *= pow(1.0-STOP_DAMP, delta * 10)
		else:
			linear_velocity *= pow(1.0-DAZED_DAMP, delta * 5)
	
	if dazed:
		var cur_mag = linear_velocity.length()
		if cur_mag <= 40 and cur_mag > 20:
			print("Skip available!")
			if input != Vector2.ZERO:
				print("Skipped!")
				dazed = false
				linear_velocity = Vector2()
		elif cur_mag <= 20:
			print("Reset to not dazed!")
			dazed = false
			linear_velocity = Vector2()
	
	if Input.is_action_just_pressed("shoot"):
		var shoot_dir = (get_global_mouse_position() - position).normalized()
		launch_projectile(shoot_dir)
		pass
	
	modulate = Color.red if dazed else Color.white
	self.physics_material_override.bounce = 1 if dazed else 0

func get_player_input() -> Vector2:
	
	var input_vec : Vector2
	
	input_vec.x -= int(Input.is_action_pressed("move_left"))
	input_vec.x += int(Input.is_action_pressed("move_right"))
	input_vec.y -= int(Input.is_action_pressed("move_up"))
	input_vec.y += int(Input.is_action_pressed("move_down"))
	
	return input_vec.normalized()

func launch_projectile(dir : Vector2):
	var proj = SELECTOR.instance()
	proj.connect("missed", self, "on_projectile_miss")
	proj.connect("hit_something", self, "on_projectile_hit")
	
	proj.position = position
	get_parent().add_child(proj)
	proj.launch(dir)

func on_projectile_miss():
	print("Missed!")

func on_projectile_hit(hit_obj):
	print("Hit ", hit_obj.name)
