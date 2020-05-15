tool
extends Node2D

#export(float) var radius = 39.0
export(float) var spin_rate = 45.0
export(bool) var is_active = true
#
#func _ready():
#	$Orb.position.x = radius
#	$Orb2.position.x = -radius

func _process(delta):
	
	if is_active:
		rotation_degrees = clamp(rotation_degrees - spin_rate * delta, -360.0, 360.0)
	
	if rotation_degrees == 360.0 or rotation_degrees == -360.0:
		rotation_degrees = 0

func activate():
#	$Orb/Particles2D.emitting = true
#	$Orb2/Particles2D.emitting = true
	is_active = true
	show()

func deactivate():
#	$Orb/Particles2D.emitting = false
#	$Orb2/Particles2D.emitting = false
	rotation_degrees = 0
	is_active = false
	hide()
