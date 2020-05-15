extends Area2D

func _ready():
	
	collision_layer = LayerManager.LAYERS.MISC
	collision_mask = LayerManager.LAYERS.PLAYER
	
	$CollisionShape2D.disabled = true

func set_active():
	$CollisionShape2D.disabled = false

func _on_Exit_body_entered(body):
	Events.emit_signal("player_left", true)
