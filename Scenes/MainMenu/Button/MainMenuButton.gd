extends Button


signal start_level

var level : int setget set_level

func _on_MainMenuButton_pressed():
	emit_signal("start_level", level)


func set_level(value:int):
	level = value
	text = str(value + 1)
