extends Area2D

const SPIN_SPEED = 0.6

func _ready():
	
	collision_layer = LayerManager.LAYERS.MISC
	collision_mask = LayerManager.LAYERS.PLAYER
	
	$CollisionShape2D.disabled = true

func _process(delta):
	$ExitSign.rotation += SPIN_SPEED * delta

func set_active():
	$CollisionShape2D.disabled = false
	$ExitSign.modulate = Color.white

func _on_Exit_body_entered(body):
	Events.emit_signal("player_left", true)
