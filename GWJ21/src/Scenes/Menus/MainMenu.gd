extends Control

var credits_on : bool = false

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
	$Menu/VBoxContainer/Credits.release_focus()
	$AnimationPlayer.play("ExitMenu")
	yield($AnimationPlayer, "animation_finished")
	$AnimationPlayer.play("EnterCredits")
	yield($AnimationPlayer, "animation_finished")
	credits_on = true

func _on_Quit_pressed():
	GameHandler.save_game()
	get_tree().quit()

func _process(delta):
	if credits_on and Input.is_action_just_pressed("pause"):
		disable_credits()
		print("Disabled!")

func disable_credits():
	credits_on = false
	$AnimationPlayer.play("ExitCredits")
	yield($AnimationPlayer, "animation_finished")
	$AnimationPlayer.play("EnterMenu")
	yield($AnimationPlayer, "animation_finished")
	$Menu/VBoxContainer/Credits.grab_focus()
