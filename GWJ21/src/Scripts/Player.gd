extends KinematicBody2D

const SELECTOR : PackedScene = preload("res://src/Scenes/SelectorProjectile.tscn")

const ACCEL = 10
const MAX_SPEED = 150
const TURN_DAMP = 0.65
const STOP_DAMP = 0.8
const DAZED_DAMP = 0.2

var dazed : bool = false # WIP
var is_dashing : bool = false # WIP
var is_casting : bool = false

var pushed_body = null
var pushed_dir = null
var push_force = ACCEL * 20.0

var selected_obj = null
var current_connection : Connection = null

onready var animation_tree = $AnimationTree
onready var animation_state = $AnimationTree.get("parameters/playback")

func _ready():
	collision_layer = LayerManager.LAYERS.PLAYER
	collision_mask = (
		LayerManager.LAYERS.ENEMIES | 
		LayerManager.LAYERS.ENEMY_PROJECTILES | 
		LayerManager.LAYERS.OBJECTS |
		LayerManager.LAYERS.WALLS
	)
	
	$Hitbox.collision_layer = collision_layer
	$Hitbox.collision_mask = (LayerManager.LAYERS.ENEMIES | 
							  LayerManager.LAYERS.ENEMY_PROJECTILES)
	
	animation_tree.active = true

var velocity : Vector2
func _physics_process(delta):
	
	var input = get_player_input()
	
	if input != Vector2.ZERO and not dazed and not is_dashing:
		velocity += input * ACCEL
		velocity = velocity.clamped(MAX_SPEED)
		
		$Sprite.flip_h = velocity.x < 0
		
		# Applies damping if the player turns too suddenly
		if input.dot(velocity.normalized()) < -0.5:
			velocity *= pow(1.0-TURN_DAMP, delta * 10)
		
		animation_state.travel("Move")
	else:
		if not dazed and not is_dashing:
			velocity *= pow(1.0-STOP_DAMP, delta * 10)
			animation_state.travel("Idle")
		elif dazed:
			velocity *= pow(1.0-DAZED_DAMP, delta * 5)
	
	if pushed_body != null and pushed_dir == velocity.normalized():
		pushed_body.velocity += velocity.normalized() * delta * push_force
	elif pushed_body != null and pushed_dir != velocity.normalized():
		pushed_body = null
		pushed_dir = null
	
	var col = move_and_collide(velocity * delta)
	if col:
		var collider = col.collider
		if collider is KinematicSelectable and collider.is_pushable == true:
			collider.velocity += velocity.normalized() * delta * push_force
			pushed_body = col.collider
			pushed_dir = velocity.normalized()
		else:
			velocity = velocity.slide(col.normal)
	
	if Input.is_action_just_pressed("shoot"):
		var shoot_dir = (get_global_mouse_position() - $LaunchPoint.global_position).normalized()
		call_deferred("launch_projectile", shoot_dir)
	
	if Input.is_action_just_pressed("ui_cancel"):
		if selected_obj != null:
			selected_obj.deselect()
			selected_obj = null
		elif current_connection != null:
			current_connection.destroy_connection(false)
	
	if Input.is_action_just_pressed("special"):
		if current_connection:
			current_connection.start_pull()
	elif Input.is_action_just_released("special"):
		if current_connection:
			current_connection.is_pulling = false
	
	if not is_casting and input != Vector2.ZERO and Input.is_action_just_pressed("dash"):
		is_dashing = true
		velocity = input * MAX_SPEED * 2.0
		$Sprite.flip_h = velocity.x < 0
		$DashTrail.emitting = true
		$DashTrail.process_material.set("shader_param/invert", $Sprite.flip_h)
		get_tree().create_timer(0.5).connect("timeout", self, "stop_dash")

func stop_dash():
	is_dashing = false
	$DashTrail.emitting = false

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
	
	proj.position = $LaunchPoint.global_position
	get_parent().add_child(proj)
	proj.launch(dir)

func on_projectile_miss():
	print("Missed!")

func on_projectile_hit(hit_obj):
	
	if selected_obj == null:
		if current_connection != null:
			current_connection.destroy_connection(false)
		selected_obj = hit_obj
		selected_obj.select()
	elif hit_obj != selected_obj:
		current_connection = Connection.new(selected_obj, hit_obj)
		current_connection.connect("connection_broken", self, "on_connection_broken")
		selected_obj = null
		hit_obj.select()
		get_parent().add_child(current_connection)

func on_connection_broken():
	current_connection = null
