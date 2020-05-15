extends Control

export(float, 0, 1) var screen_rumble = 0.0

onready var anim_player = $AnimationPlayer

func _ready():
	randomize()
	
	Events.connect("level_button_clicked", self, "enter_level")
	
	anim_player.play("EnterMap")
	
	yield(anim_player, "animation_finished")
	
	if GameHandler.last_completed_level != null:
		anim_player.play("MarkCompleted")
		yield(anim_player, "animation_finished")
	
	grab_level_focus()

func _process(delta):
	if screen_rumble > 0:
		rumble_screen()
	else:
		rect_rotation = 0.0

func rumble_screen():
	var amount = screen_rumble * screen_rumble
	rect_rotation = 10.0 * amount * rand_range(-1, 1)

func unlock_levels():
	for button in $LevelIcons.get_children():
		if GameHandler.level_unlock_table[button.level_id] == true:
			button.show()

func mark_levels_as_completed():
	for button in $LevelIcons.get_children():
		if GameHandler.level_completion_table[button.level_id] == true:
			if button.level_id != GameHandler.last_completed_level:
				button.set_completed()

func mark_last_completed_level():
	if GameHandler.last_completed_level != null:
		for button in $LevelIcons.get_children():
			if button.level_id == GameHandler.last_completed_level:
				button.set_completed()
				GameHandler.last_completed_level = null
				break

func grab_level_focus():
	if GameHandler.last_level_id != null:
		for button in $LevelIcons.get_children():
			if button.level_id == GameHandler.last_level_id:
				button.grab_focus()
				break
	else:
		$LevelIcons/Button.grab_focus()

func enter_level(level_id):
	
	anim_player.play("ExitMap")
	yield(anim_player, "animation_finished")
	
	GameHandler.change_to_level(level_id)

func _on_MainMenuButton_pressed():
	anim_player.play("ExitMap")
	yield(anim_player, "animation_finished")
	
	GameHandler.return_to_main_menu()
