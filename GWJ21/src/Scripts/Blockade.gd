extends StaticBody2D

var is_locked := false

func _ready():
	
	collision_layer = LayerManager.LAYERS.WALLS
	collision_mask = LayerManager.get_all_layers([
		LayerManager.LAYERS.CONNECTION_HITBOX,
		LayerManager.LAYERS.MISC
	])
	
	hide()

func lock():
	if $Tween.is_connected("tween_all_completed", self, "hide"):
		$Tween.disconnect("tween_all_completed", self, "hide")
	
	show()
	$CollisionShape2D.set_deferred("disabled", false)
	$Tween.interpolate_property($Lock, "scale", Vector2.ZERO, Vector2(4,4), 0.2,
								Tween.TRANS_BACK, Tween.EASE_OUT)
	$Tween.interpolate_property($Left, "scale:x", 0, 4, 0.5,
								Tween.TRANS_CUBIC, Tween.EASE_OUT)
	$Tween.interpolate_property($Right, "scale:x", 0, 4, 0.5,
								Tween.TRANS_CUBIC, Tween.EASE_OUT)
	
	$Tween.start()

func unlock():
	$CollisionShape2D.set_deferred("disabled", true)
	$Tween.interpolate_property($Lock, "scale", Vector2(4,4), Vector2.ZERO, 0.2,
								Tween.TRANS_BACK, Tween.EASE_OUT)
	$Tween.interpolate_property($Left, "scale:x", 4, 0, 0.5,
								Tween.TRANS_CUBIC, Tween.EASE_OUT)
	$Tween.interpolate_property($Right, "scale:x", 4, 0, 0.5,
								Tween.TRANS_CUBIC, Tween.EASE_OUT)
	
	if not $Tween.is_connected("tween_all_completed", self, "hide"):
		$Tween.connect("tween_all_completed", self, "hide")
	
	$Tween.start()
