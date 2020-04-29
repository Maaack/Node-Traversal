tool
extends ChapterTwoLevel


class_name ChapterThreeLevel

onready var yellow_unlocks_count_node = $ToolsNode/YellowUnlocksCounter/UnlocksCount

export(int) var starting_yellow_unlocks : int = 1 setget set_starting_yellow_unlocks

var current_yellow_unlocks

func _ready():
	._ready()

func _reset_locks():
	current_yellow_unlocks = starting_yellow_unlocks
	._reset_locks()

func _can_unlock(node:IntrusionNode) -> bool:
	if node.is_in_group('YELLOW_NODE'):
		return current_yellow_unlocks > 0
	return ._can_unlock(node)

func _remove_unlock(node:IntrusionNode):
	if node.is_in_group('YELLOW_NODE'):
		current_yellow_unlocks -= 1
		_update_tool_counts()
	._remove_unlock(node)

func _update_tool_counts():
	if is_instance_valid(yellow_unlocks_count_node):
		yellow_unlocks_count_node.text = "%d / %d" % [current_yellow_unlocks, starting_yellow_unlocks]
	._update_tool_counts()

func set_starting_yellow_unlocks(value:int):
	starting_yellow_unlocks = value
	if starting_yellow_unlocks != null:
		_update_tool_counts()
