extends Control

func _ready():
	$AnimationPlayer.play("Final Monologue (Part 1)")
	yield($AnimationPlayer, "animation_finished")
	$AnimationPlayer.play("Final Monologue (Part 2)")
	yield($AnimationPlayer, "animation_finished")	
	$AnimationPlayer.play("Final Monologue (Part 3)")
	yield($AnimationPlayer, "animation_finished")
	$AnimationPlayer.play("Final Monologue (Part 4)")
	yield($AnimationPlayer, "animation_finished")
	GameHandler.return_to_main_menu()
