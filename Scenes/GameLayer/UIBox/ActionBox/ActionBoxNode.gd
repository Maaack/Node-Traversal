extends Node2D


onready var label_node = $ActionBox/MarginContainer/Control/HBoxContainer/Label

export(Resource) var intrusion_node setget set_intrusion_node

func _process(delta):
	update_text()

func set_intrusion_node(value:IntrusionNode):
	intrusion_node = value
	update_text()

func update_text():
	var action_text = ""
	var cost_text = ""
	if not is_instance_valid(label_node) or not is_instance_valid(intrusion_node):
		return
	if not intrusion_node.action is IntrusionAction:
		return
	var action = intrusion_node.action
	action_text = action.text
	if action.cost != 0:
		cost_text = " ( %d )" % action.cost
	if action is RangedCostAction:
		cost_text = " ( %d - %d )" % [action.min_cost, action.max_cost]
	label_node.text = action_text + cost_text
