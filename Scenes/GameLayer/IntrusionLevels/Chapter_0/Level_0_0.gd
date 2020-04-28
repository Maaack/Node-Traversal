tool
extends IntrusionLevel


class_name ChapterOneLevel

onready var unlocks_count_node = $ToolsNode/UnlocksCounter/UnlocksCount

export(int) var starting_unlocks : int = 2 setget set_starting_unlocks

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
			_remove_unlock(node)

func _can_unlock(node:IntrusionNode) -> bool :
	if node.is_in_group('BLUE_NODE') or node.is_in_group('GREEN_NODE'):
		return current_unlocks > 0
	return false

func _remove_unlock(node:IntrusionNode):
	if node.is_in_group('BLUE_NODE') or node.is_in_group('GREEN_NODE'):
		current_unlocks -= 1
		_update_tool_counts()

func _reset_locks():
	current_unlocks = starting_unlocks
	_update_tool_counts()

func _reset_level():
	_reset_locks()
	._reset_level()

func set_starting_unlocks(value:int):
	starting_unlocks = value
	if starting_unlocks != null:
		_update_tool_counts()
