extends Node2D


onready var label_node = $ActionBox/MarginContainer/Control/HBoxContainer/Label

export(Resource) var intrusion_node setget set_intrusion_node

func _process(delta):
	update_text()

func set_intrusion_node(value:IntrusionNode):
	intrusion_node = value
	update_text()

func update_text():
	if not is_instance_valid(label_node) or not is_instance_valid(intrusion_node):
		return
	label_node.text = intrusion_node.action_text
