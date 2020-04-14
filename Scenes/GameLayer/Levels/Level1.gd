extends Node2D


class_name Level_One

var action_box_scene = preload("res://Scenes/GameLayer/UIBox/ActionBox/ActionBox.tscn")
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


func _on_IntrusionNode_mouse_entered():
	pass

func _on_IntrusionNode_mouse_exited():
	pass

func add_action_box(node:IntrusionNode):
	var key = node.get_id()
	var action_box
	if node_action_box_map.has(key):
		action_box = node_action_box_map[key]
		action_box.show()
		return action_box
	action_box = action_box_scene.instance()
	
