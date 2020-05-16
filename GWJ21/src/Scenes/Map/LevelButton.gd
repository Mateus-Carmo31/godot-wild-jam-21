extends Button

const COMPLETED_STYLE = preload("res://src/Scenes/Map/LevelButtonCompleted.tres")

func _ready():
	pass

func _on_Button_focus_entered():
	$TextureRect.show()

func _on_Button_focus_exited():
	$TextureRect.hide()

func _on_Button_pressed():
	Events.emit_signal("level_button_clicked", name)
	release_focus()

func set_completed():
	self.set("custom_styles/hover", COMPLETED_STYLE)
	self.set("custom_styles/pressed", COMPLETED_STYLE)
	self.set("custom_styles/focus", COMPLETED_STYLE)
	self.set("custom_styles/disabled", COMPLETED_STYLE)
	self.set("custom_styles/normal", COMPLETED_STYLE)
