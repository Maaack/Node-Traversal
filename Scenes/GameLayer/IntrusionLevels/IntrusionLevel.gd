extends Node2D


class_name IntrusionLevel

signal destination_reached

onready var camera_node = $Camera2D

export(Vector2) var action_box_position_offset = Vector2(0, 120)
export(Vector2) var action_box_margin = Vector2(128, 48)

var action_box_scene = preload("res://Scenes/GameLayer/UIBox/ActionBox/ActionBoxNode.tscn")
var player_character = preload("res://Scenes/GameLayer/Character/PlayerCharacter.tres")
var node_action_box_map = {}
var highlighted_node

func _ready():
	for level_child in get_children():
		if not is_instance_valid(level_child):
			continue
		if not level_child is Node:
			continue
		if level_child.is_in_group('NODE'):
			level_child.connect("mouse_entered", self, "_on_IntrusionNode_mouse_entered")
			level_child.connect("mouse_exited", self, "_on_IntrusionNode_mouse_exited")
			if level_child.is_in_group('DESTINATION'):
				level_child.connect("destination_reached", self, "_on_DestinationNode_destination_reached")

func _input(event):
	if event.is_action_pressed("game_trigger_action"):
		if not is_instance_valid(highlighted_node):
			return
		if highlighted_node is IntrusionNode:
			highlighted_node.connect_character(player_character)

func _on_IntrusionNode_mouse_entered(node:IntrusionNode):
	if not is_instance_valid(node):
		return
	highlighted_node = node
	if node.action != null:
		show_action_box(node)

func _on_IntrusionNode_mouse_exited(node:IntrusionNode):
	if node == highlighted_node:
		highlighted_node = null
	if is_instance_valid(node):
		hide_action_box(node)

func _on_DestinationNode_destination_reached(character:IntrusionCharacter, node:IntrusionNode):
	if character.intrusion_id == player_character.intrusion_id:
		emit_signal("destination_reached", self)

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
		action_box.position = move_inside_action_box_margin(action_box.position)
		action_box.intrusion_node = node
		node_action_box_map[key] = action_box
	return action_box

func move_inside_action_box_margin(position:Vector2):
	var size = get_viewport().size
	if position.x < action_box_margin.x:
		position.x = action_box_margin.x
	if position.x > size.x - action_box_margin.x:
		position.x = size.x - action_box_margin.x
	if position.y < action_box_margin.y:
		position.y = action_box_margin.y
	if position.y > size.y - action_box_margin.y:
		position.y = size.y - action_box_margin.y
	return position

func hide_action_box(node:IntrusionNode):
	var key = node.get_instance_id()
	var action_box
	if node_action_box_map.has(key):
		action_box = node_action_box_map[key]
		action_box.hide()
