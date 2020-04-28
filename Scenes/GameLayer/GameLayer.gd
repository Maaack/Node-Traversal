extends Control


onready var camera_node = $Game/Camera2D
onready var game_node = $Game

export(int, 0, 1024) var starting_level_index = 0

var levels = {}
var current_level_index
var current_level_node: IntrusionLevel

func _ready():
	var level_index = 0
	for game_child in game_node.get_children():
		if game_child.is_in_group('LEVEL') and game_child is IntrusionLevel:
			levels[level_index] = game_child
			level_index += 1
			game_child.connect("destination_reached", self, "_on_Level_destination_reached")
			game_child.ignore_input = true
	_start_first_level()

func _input(event):
	current_level_node.game_input(event)

func _on_Level_destination_reached(level:IntrusionLevel):
		_transition_to_next_level()

func _transition_to_next_level():
	set_current_level_index(current_level_index + 1)

func _start_first_level():
	set_current_level_index(starting_level_index)

func set_current_level_index(index:int):
	current_level_index = index
	if current_level_index == null or current_level_index < 0:
		return
	_set_current_level_from_index()

func _set_current_level_from_index():
	if levels.has(current_level_index):
		current_level_node = levels[current_level_index]
		camera_node.global_position = current_level_node.camera_node.global_position
		camera_node.zoom = current_level_node.camera_node.zoom
