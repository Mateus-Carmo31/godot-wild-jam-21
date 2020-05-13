extends Control

func _ready():
	Events.connect("player_health_changed", self, "update_health_display")
	Events.connect("player_lives_changed", self, "update_lives_display")

# WIP
func update_health_display(new_health):
	$Label.text = "Health: %s" % [new_health]

func update_lives_display(new_lives):
	$Label2.text = "Lives: %s" % [new_lives]
