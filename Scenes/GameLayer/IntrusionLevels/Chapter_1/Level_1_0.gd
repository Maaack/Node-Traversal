tool
extends ChapterZeroLevel


class_name ChapterOneLevel

onready var red_unlocks_count_node = $ToolsNode/RedUnlocksCounter/UnlocksCount

export(int) var starting_red_unlocks : int = 1 setget set_starting_red_unlocks

var current_red_unlocks

func _ready():
	._ready()

func _reset_locks():
	current_red_unlocks = starting_red_unlocks
	._reset_locks()

func _can_unlock(node:IntrusionNode) -> bool:
	if node.is_in_group('RED_NODE'):
		return current_red_unlocks > 0
	return ._can_unlock(node)

func _remove_unlock(node:IntrusionNode):
	if node.is_in_group('RED_NODE'):
		current_red_unlocks -= 1
		_update_tool_counts()
	._remove_unlock(node)

func _update_tool_counts():
	if is_instance_valid(red_unlocks_count_node):
		red_unlocks_count_node.text = "%d / %d" % [current_red_unlocks, starting_red_unlocks]
	._update_tool_counts()

func set_starting_red_unlocks(value:int):
	starting_red_unlocks = value
	if starting_red_unlocks != null:
		_update_tool_counts()
