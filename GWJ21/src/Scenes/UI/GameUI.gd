tool
extends Control

export(float, 0, 5) var blur_amount = 0.0 setget set_blur

onready var anim_player := $AnimationPlayer

func _ready():
	Events.connect("player_health_changed", self, "update_health_display")
	Events.connect("player_lives_changed", self, "update_lives_display")

# WIP
func update_health_display(new_health):
	$Label.text = "Health: %s" % [new_health]

func update_lives_display(new_lives):
	$Label2.text = "Lives: %s" % [new_lives]

func pause_screen():
	anim_player.play("Pause")

func unpause_screen():
	anim_player.play("Unpause")

func death_screen():
	pass

func set_blur(amount):
	($BlurRect.material as ShaderMaterial).set_shader_param("amount", amount)
	blur_amount = amount
