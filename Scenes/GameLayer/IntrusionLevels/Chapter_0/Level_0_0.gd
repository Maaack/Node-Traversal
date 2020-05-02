tool
extends IntrusionLevel


class_name ChapterZeroLevel

const FOCUS_TOOL_ANIMATION = 'Focus'

onready var unlocks_count_node = $ToolsNode/UnlocksCounter/UnlocksCount
onready var animation_node = $ToolsNode/AnimationPlayer
onready var connect_audio_node = $ConnectAudio
onready var error_audio_node = $ErrorAudio

export(int) var starting_unlocks : int = 1 setget set_starting_unlocks

var current_unlocks

func _ready():
	._ready()

func _update_tool_counts():
	if is_instance_valid(unlocks_count_node):
		unlocks_count_node.text = "%d / %d" % [current_unlocks, starting_unlocks]

func _connect_player_to_node(node:IntrusionNode):
	if _can_unlock(node):
		var connected = ._connect_player_to_node(node)
		if connected:
			if is_instance_valid(connect_audio_node):
				connect_audio_node.play()
			_remove_unlock(node)
		else:
			if is_instance_valid(error_audio_node):
				error_audio_node.play()
	else:
		if is_instance_valid(error_audio_node):
			error_audio_node.play()

func _can_unlock(node:IntrusionNode) -> bool :
	if node.is_in_group('GREEN_NODE'):
		return true
	if node.is_in_group('BLUE_NODE'):
		return current_unlocks > 0
	return false

func _remove_unlock(node:IntrusionNode):
	if node.is_in_group('BLUE_NODE'):
		current_unlocks -= 1
		_update_tool_counts()

func _reset_locks():
	current_unlocks = starting_unlocks
	_update_tool_counts()

func _reset_animations():
	if is_instance_valid(animation_node):
		animation_node.current_animation = FOCUS_TOOL_ANIMATION

func reset_level():
	_reset_locks()
	_reset_animations()
	.reset_level()

func set_starting_unlocks(value:int):
	starting_unlocks = value
	if starting_unlocks != null:
		_update_tool_counts()
