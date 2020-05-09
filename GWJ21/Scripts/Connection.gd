extends Line2D
class_name Connection

const PULL_ACCEL = 100.0

var body1 : SelectableBody = null
var body2 : SelectableBody = null

signal connection_broken

func _init(o1 : SelectableBody, o2 : SelectableBody):
	self.body1 = o1
	self.body2 = o2
	
	o1.get_node("./Hitbox").connect("area_entered", self, "on_hitbox_entered", [o1])
	o2.get_node("./Hitbox").connect("area_entered", self, "on_hitbox_entered", [o2])
	
	self.add_point(o1.position)
	self.add_point(o2.position)

func _physics_process(delta):
	
	set_point_position(0, body1.position)
	set_point_position(1, body2.position)
	
	get_velocity_based_on_connection()
	
	if Input.is_action_just_pressed("ui_cancel"):
		destroy_connection()
		pass
	
	if Input.is_action_pressed("special"):
		pull_together(delta)
#	print("Connection between ", body1.name, " and ", body2.name, " present!")

func get_velocity_based_on_connection():
	
	var body1_to_body2 = body1.position.direction_to(body2.position)
	var final_speed_1 = body1.linear_velocity.project(body1_to_body2).length()
	var final_speed_2 = body2.linear_velocity.project(body1_to_body2).length()
	
	return [final_speed_1, final_speed_2]

func destroy_connection():
	emit_signal("connection_broken")
	body1.is_selected = false
	body2.is_selected = false
	
	queue_free()

func pull_together(delta):
	var towards_body2 = body1.position.direction_to(body2.position)
	var towards_body1 = body2.position.direction_to(body1.position)
	
	body1.linear_velocity += towards_body2 * PULL_ACCEL * delta
	body2.linear_velocity += towards_body1 * PULL_ACCEL * delta

func on_hitbox_entered(detected_area, detecting_body):
	
	var detected_body = detected_area.get_parent()
	
	if detecting_body == body1 and detected_body == body2:
		print("Hit with speed ", get_velocity_based_on_connection()[1])
	elif detecting_body == body2 and detected_body == body1:
		print("Hit with speed ", get_velocity_based_on_connection()[0])
