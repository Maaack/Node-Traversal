tool
extends Node


class_name IntrusionCharacter

export(String) var character_name setget set_character_name
export(NodePath) var occupying_node_path setget set_occupying_node_path
var occupying_node

func _process(_delta):
	resolve_paths_to_nodes()

func set_character_name(value:String):
	character_name = value

func set_occupying_node_path(value:NodePath):
	occupying_node_path = value
	resolve_paths_to_nodes()

func resolve_paths_to_nodes():
	if occupying_node_path == null:
		return
	occupying_node = get_node_or_null(occupying_node_path)
	if is_instance_valid(occupying_node) and occupying_node.has_method('enter_node'):
		occupying_node.enter_node(self)
