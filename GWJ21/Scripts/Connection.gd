extends Line2D
class_name Connection

const PULL_ACCEL = 200.0

var body1 : KinematicSelectable = null
var body2 : KinematicSelectable = null

signal connection_broken

func _init(o1, o2):
	
	if not ((o1.has_method("pull_towards") and o1.has_method("get_speed_projected_on_dir"))):
		print("Error! Invalid Object!")
	if not ((o2.has_method("pull_towards") and o2.has_method("get_speed_projected_on_dir"))):
		print("Error! Invalid Object!")
	
	self.body1 = o1
	self.body2 = o2
	
	o1.get_collision_area().connect("area_entered", self, "on_hitbox_entered", [o1])
	o1.connect("connection_released", self, "destroy_connection")
	o2.connect("connection_released", self, "destroy_connection")
	
	self.add_point(o1.position)
	self.add_point(o2.position)

func _physics_process(delta):
	
	if body1 and body2:
		set_point_position(0, body1.global_position)
		set_point_position(1, body2.global_position)
		
		if Input.is_action_pressed("special"):
			body1.is_being_pulled = true
			body2.is_being_pulled = true
			pull_together(delta)
		else:
			body1.is_being_pulled = false
			body2.is_being_pulled = false
		
		if Input.is_action_just_pressed("ui_cancel"):
			destroy_connection()

func destroy_connection():
	emit_signal("connection_broken")
	
	body1.get_collision_area().disconnect("area_entered", self, "on_hitbox_entered")
	body1.disconnect("connection_released", self, "destroy_connection")
	body2.disconnect("connection_released", self, "destroy_connection")
	body1.deselect()
	body2.deselect()
	
	Events.emit_signal("screen_shake", 0.3)
	
	body1 = null
	body2 = null
	
	queue_free()

func pull_together(delta):
	
	if body1.is_static and body2.is_static:
		destroy_connection()
		return
	
	
	var towards_body2 = body1.position.direction_to(body2.position)
	var towards_body1 = body2.position.direction_to(body1.position)
	
	# Makes it so lighter bodies are pulled faster to heavier bodies (and vice-versa)
	var mass_ratio : float = (body2.mass / body1.mass)
	
	# In case one of the objects is fixed, avoid complications
	if body1.is_static or body2.is_static:
		mass_ratio = 1
	
	if body1.is_static == false:
		body1.pull_towards(towards_body2, PULL_ACCEL * mass_ratio, delta)
	
	if body2.is_static == false:
		body2.pull_towards(towards_body1, PULL_ACCEL * (1/mass_ratio), delta)

func on_hitbox_entered(detected_area, detecting_body):
	
	var detected_body = detected_area.get_parent()
	
	var body1_to_body2 = body1.position.direction_to(body2.position)
	var body2_to_body1 = body2.position.direction_to(body1.position)
	
	if detecting_body == body1 and detected_body == body2:
		
		var body1_speed = body1.get_speed_projected_on_dir(body1_to_body2)
		var body2_speed = body2.get_speed_projected_on_dir(body1_to_body2)
		
		body1.call_deferred("on_collision", -body1_to_body2, body2)
		body2.call_deferred("on_collision", -body1_to_body2, body1)
		
#		if body1_speed >= KinematicSelectable.DAMAGE_DEALING_SPEED:
#			body2.call_deferred("on_collision", -body2_to_body1, body1.damage)
#			if body1.takes_self_damage:
#				body1.call_deferred("on_collision", -body1_to_body2, body2.damage)
#
#		if body2_speed >= KinematicSelectable.DAMAGE_DEALING_SPEED:
#			body1.call_deferred("on_collision", -body1_to_body2, body2.damage)
#			if body2.takes_self_damage:
#				body2.call_deferred("on_collision", -body2_to_body1, body1.damage)
#
#		if (body1_speed <= KinematicSelectable.DAMAGE_DEALING_SPEED and
#			body2_speed <= KinematicSelectable.DAMAGE_DEALING_SPEED):
#			body1.call_deferred("on_collision", -body1_to_body2, 0)
#			body2.call_deferred("on_collision", -body2_to_body1, 0)
		
		destroy_connection()
