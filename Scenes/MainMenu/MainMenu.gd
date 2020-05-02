extends Control


onready var level_grid_node = $MarginContainer/Control/VBoxContainer/MarginContainer/Control/VBoxContainer/HBoxContainer/GridContainer

signal start_level
signal exit_game

var level_button = preload("res://Scenes/MainMenu/Button/MainMenuButton.tscn")
var max_levels : int setget set_max_levels

func _on_StartGame_pressed():
	emit_signal("start_level", 0)
	hide()

func _on_LevelButton_start_level(level:int):
	emit_signal("start_level", level)
	hide()

func _on_ExitGame_pressed():
	emit_signal("exit_game")
	get_tree().quit()

func set_max_levels(value:int):
	max_levels = value
	var button_node
	if level_grid_node == null:
		return
	for i in range(max_levels):
		button_node = level_button.instance()
		button_node.level = i
		level_grid_node.add_child(button_node)
		button_node.connect("start_level", self, "_on_LevelButton_start_level")
	button_node.hide() # Hide win screen
