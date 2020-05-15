extends Control

export(float, 0, 5) var blur_amount = 0.0 setget set_blur
export(float) var lives_display_rumble = 0.0

export var current_lives : int = 3

onready var anim_player := $AnimationPlayer
onready var blur_rect := $Blur

func _ready():
	randomize()
	Events.connect("player_health_changed", self, "update_health_display")
	Events.connect("player_lives_changed", self, "update_lives_display")

func _process(delta):
	if lives_display_rumble > 0.0:
		rumble_lives_display()
	else:
		if $DeathLivesDisplay.rect_rotation != 0:
			$DeathLivesDisplay.rect_rotation = 0

# WIP
func update_health_display(new_health):
	$Label.text = "Health: %s" % [new_health]

func update_lives_display(new_lives):
	$PauseLivesDisplay/Label.text = str(new_lives)
	current_lives = new_lives

func update_death_lives_display():
	$DeathLivesDisplay/Label.text = str(current_lives)

func pause_screen():
	anim_player.play("Pause")
	$PauseMenu/RestartLevel.grab_focus()

func unpause_screen():
	anim_player.play("Unpause")
	$PauseMenu/RestartLevel.release_focus()
	$PauseMenu/QuitMenu.release_focus()

func death_animations():
	anim_player.queue("ScreenWipe")
	yield(anim_player, "animation_finished")
	anim_player.queue("Update Lives")
	yield(anim_player, "animation_finished")
	
	Events.emit_signal("death_animation_ended")

func unwipe():
	anim_player.play("ScreenUnwipe")

func set_blur(amount):
	(blur_rect.material as ShaderMaterial).set_shader_param("amount", amount)
	blur_amount = amount

func rumble_lives_display():
	var amount = lives_display_rumble * lives_display_rumble
	$DeathLivesDisplay.rect_rotation = 10.0 * amount * rand_range(-1, 1)

func _on_RestartLevel_pressed():
	pass # Replace with function body.
