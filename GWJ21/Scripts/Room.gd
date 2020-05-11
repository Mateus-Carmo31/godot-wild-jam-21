extends Area2D
class_name Room

onready var checkpoint = $Checkpoint

func _ready():
	pass

func _on_Room_body_entered(body):
	Events.emit_signal("wants_cam_focus", $CamPoint.get_path())

func _on_Room_body_exited(body):
	Events.emit_signal("released_cam_focus")
