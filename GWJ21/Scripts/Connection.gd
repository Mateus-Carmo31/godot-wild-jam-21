extends Line2D
class_name Connection

const PULL_ACCEL = 200.0

var body1 : KinematicSelectable = null
var body2 : KinematicSelectable = null

var is_pulling = false

signal connection_broken

func _init(o1 : KinematicSelectable, o2 : KinematicSelectable):
	
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
		
		if is_pulling:
			body1.is_being_pulled = true
			body2.is_being_pulled = true
			pull_together(delta)
		else:
			body1.is_being_pulled = false
			body2.is_being_pulled = false

func destroy_connection(trigger_screen_shake = true):
	emit_signal("connection_broken")
	
	body1.get_collision_area().disconnect("area_entered", self, "on_hitbox_entered")
	body1.disconnect("connection_released", self, "destroy_connection")
	body2.disconnect("connection_released", self, "destroy_connection")
	body1.deselect()
	body2.deselect()
	
	if trigger_screen_shake:
		Events.emit_signal("screen_shake", 0.3)
	
	body1 = null
	body2 = null
	
	queue_free()

func start_pull():
	var current_overlaps = body1.get_collision_area().get_overlapping_areas()
	
	if current_overlaps.has(body2.get_collision_area()):
		print("Too close!")
		destroy_connection(false)
	else:
		is_pulling = true
	

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
		
		body1.call_deferred("on_collision", -body1_to_body2, body2)
		body2.call_deferred("on_collision", -body1_to_body2, body1)
		
		destroy_connection()
