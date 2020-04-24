tool
extends IntrusionPath


class_name WeightedPath

onready var weight_node = $Weight

export(int, 0, 1024) var weight: int = 1 setget set_weight

func _process(delta):
	update_text()

func set_weight(value:int):
	weight = value
	update_text()

func update_text():
	if weight != null and is_instance_valid(weight_node):
		weight_node.text = str(weight)
