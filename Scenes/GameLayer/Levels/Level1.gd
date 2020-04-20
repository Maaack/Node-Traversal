extends Node2D


class_name Level_One

export(Vector2) var action_box_position_offset = Vector2(-160, 0)

var action_box_scene = preload("res://Scenes/GameLayer/UIBox/ActionBox/ActionBoxNode.tscn")
var node_action_box_map = {}

func _ready():
	for child in get_children():
		if not is_instance_valid(child):
			continue
		if not child is Node:
			continue
		if child.is_in_group('NODE'):
			child.connect("mouse_entered", self, "_on_IntrusionNode_mouse_entered")
			child.connect("mouse_exited", self, "_on_IntrusionNode_mouse_exited")

func _on_IntrusionNode_mouse_entered(node:IntrusionNode):
	show_action_box(node)

func _on_IntrusionNode_mouse_exited(node:IntrusionNode):
	hide_action_box(node)

func show_action_box(node:IntrusionNode):
	var key = node.get_instance_id()
	var action_box
	if node_action_box_map.has(key):
		action_box = node_action_box_map[key]
		action_box.show()
	else:
		action_box = action_box_scene.instance()
		add_child(action_box)
		action_box.position = node.position + action_box_position_offset
		action_box.intrusion_node = node
		node_action_box_map[key] = action_box
	return action_box
	
func hide_action_box(node:IntrusionNode):
	var key = node.get_instance_id()
	var action_box
	if node_action_box_map.has(key):
		action_box = node_action_box_map[key]
		action_box.hide()
