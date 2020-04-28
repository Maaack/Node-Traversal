tool
extends IntrusionLevel


class_name ChapterOneLevel

onready var unlocks_count_node = $ToolsNode/UnlocksCounter/UnlocksCount

export(int) var starting_unlocks : int = 2 setget set_starting_unlocks

var current_unlocks

func _ready():
	_reset_level()

func _update_tool_counts():
	if is_instance_valid(unlocks_count_node):
		unlocks_count_node.text = "%d / %d" % [current_unlocks, starting_unlocks]

func _connect_player_to_node(node:IntrusionNode):
	if current_unlocks > 0:
		var connected = ._connect_player_to_node(node)
		if connected:
			current_unlocks -= 1
			_update_tool_counts()

func _reset_level():
	._reset_level()
	current_unlocks = starting_unlocks
	_update_tool_counts()

func set_starting_unlocks(value:int):
	starting_unlocks = value
	if starting_unlocks != null:
		_update_tool_counts()
