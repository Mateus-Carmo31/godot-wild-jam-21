extends Area2D
class_name Room

export(float) var cam_zoom = 1.0

onready var checkpoint = $Checkpoint

func _ready():
	pass

func _on_Room_body_entered(_body):
	Events.emit_signal("wants_cam_focus", $CamPoint.get_path(), cam_zoom)

func _on_Room_body_exited(_body):
	Events.emit_signal("released_cam_focus")
