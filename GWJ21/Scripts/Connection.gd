extends Line2D
class_name Connection

const PULL_ACCEL = 200.0

var body1 = null
var body2 = null

signal connection_broken

func _init(o1, o2):
	
	if not ((o1.has_method("pull_towards") and o1.has_method("get_speed_projected_on_dir"))):
		print("Error! Invalid Object!")
	if not ((o2.has_method("pull_towards") and o2.has_method("get_speed_projected_on_dir"))):
		print("Error! Invalid Object!")
	
	self.body1 = o1
	self.body2 = o2
	
	o1.get_collision_area().connect("area_entered", self, "on_hitbox_entered", [o1])
	o2.get_collision_area().connect("area_entered", self, "on_hitbox_entered", [o2])
	o1.connect("connection_released", self, "destroy_connection")
	o2.connect("connection_released", self, "destroy_connection")
	
	self.add_point(o1.position)
	self.add_point(o2.position)

func _physics_process(delta):
	
	set_point_position(0, body1.position)
	set_point_position(1, body2.position)
	
	if Input.is_action_just_pressed("ui_cancel"):
		destroy_connection()
	
	if Input.is_action_pressed("special"):
		pull_together(delta)
#	print("Connection between ", body1.name, " and ", body2.name, " present!")

func destroy_connection():
	emit_signal("connection_broken")
	body1.is_selected = false
	body2.is_selected = false
	
	Events.emit_signal("screen_shake", 0.3)
	
	queue_free()

func pull_together(delta):
	var towards_body2 = body1.position.direction_to(body2.position)
	var towards_body1 = body2.position.direction_to(body1.position)
	
	body1.pull_towards(towards_body2, PULL_ACCEL, delta)
	body2.pull_towards(towards_body1, PULL_ACCEL, delta)

func on_hitbox_entered(detected_area, detecting_body):
	
	var detected_body = detected_area.get_parent()
	
	var body1_to_body2 = body1.position.direction_to(body2.position)
	
	if detecting_body == body1 and detected_body == body2:
		var collision_speed = body2.get_speed_projected_on_dir(body1_to_body2)
		print(body1.name, ": hit with speed ", collision_speed)
		body1.on_collision(collision_speed)
		body2.on_collision(collision_speed)
		destroy_connection()
	
	elif detecting_body == body2 and detected_body == body1:
		var collision_speed = body1.get_speed_projected_on_dir(body1_to_body2)
		print(body2.name, ": hit with speed ", collision_speed)
		body1.on_collision(collision_speed)		
		body2.on_collision(collision_speed)
		destroy_connection()
