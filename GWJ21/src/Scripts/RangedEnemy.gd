extends Enemy

func _on_collision(collided_with : KinematicSelectable):
	._on_collision(collided_with)
	print("Ranged Enemy!")

func _pull_towards(pull_dir : Vector2, pull_accel : float, delta : float):
	._pull_towards(pull_dir, pull_accel, delta)
	print("Pulling a ranged enemy!")
