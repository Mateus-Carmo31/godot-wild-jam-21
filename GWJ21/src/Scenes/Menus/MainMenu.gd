extends Control

func _ready():
	
	$AnimationPlayer.play("EnterMenu")
	yield($AnimationPlayer, "animation_finished")
	
	$Menu/VBoxContainer/Start.grab_focus()

func _on_Start_pressed():
	$Menu/VBoxContainer/Start.release_focus()
	$AnimationPlayer.play("ExitMenu")
	yield($AnimationPlayer, "animation_finished")
	
	get_tree().change_scene_to(RESOURCES.MAP_MENU)

func _on_Credits_pressed():
	pass # Replace with function body.

func _on_Quit_pressed():
	GameHandler.save_game()
	get_tree().quit()
