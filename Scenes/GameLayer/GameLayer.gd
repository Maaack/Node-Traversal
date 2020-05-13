extends Control


onready var camera_node = $Camera2D
onready var game_node = $Game
onready var menu_node = $MainMenu
onready var music_audio_node = $MusicAudio

export(int, 0, 1024) var starting_level_index = 0

var levels = {}
var max_levels
var current_level_index
var current_level_node : IntrusionLevel
var init_window_size : Vector2 = Vector2(1024,600)
var camera_scale_mod : float

func _ready():
	var level_index = 0
	for game_child in game_node.get_children():
		if game_child.is_in_group('LEVEL') and game_child is IntrusionLevel:
			levels[level_index] = game_child
			level_index += 1
			game_child.connect("destination_reached", self, "_on_Level_destination_reached")
			game_child.ignore_input = true
	max_levels = level_index
	menu_node.max_levels = max_levels
	_start_first_level()

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		camera_node.position = Vector2(0,0)
		camera_node.zoom = Vector2(1,1)
		menu_node.show()
	if event.is_action_pressed("game_music_toggle"):
		music_audio_node.playing = !(music_audio_node.playing)
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
		reset_camera_zoom()
		current_level_node.reset_level()

func _on_MainMenu_start_level(level:int):
	set_current_level_index(level)

func _on_GameLayer_resized():
	reset_camera_zoom()

func reset_camera_zoom():
	var camera_scale_vector = init_window_size / get_rect().size
	camera_scale_mod = min(camera_scale_vector.x, camera_scale_vector.y)
	camera_node.zoom = current_level_node.camera_node.zoom * camera_scale_mod
