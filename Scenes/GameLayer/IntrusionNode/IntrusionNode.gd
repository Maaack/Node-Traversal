tool
extends Node2D


class_name IntrusionNode

onready var ring_node = $AnimatedRing
onready var center_node = $Center

signal mouse_entered
signal mouse_exited

export(Resource) var occupying_character setget set_occupying_character
export(Resource) var action

var mouse_hovering = false
var connected_nodes = []

func _process(_delta):
	update_ring()

func _on_Area2D_mouse_entered():
	emit_signal("mouse_entered", self)
	mouse_hovering = true
	update_ring()

func _on_Area2D_mouse_exited():
	emit_signal("mouse_exited", self)
	mouse_hovering = false
	update_ring()

func set_occupying_character(character:IntrusionCharacter):
	occupying_character = character
	update_ring()

func update_ring():
	if ring_node == null:
		return
	if is_occupied():
		ring_node.modulate = occupying_character.color
		ring_node.animation = 'closed'
	else:
		ring_node.modulate = Color(1,1,1,1)
		ring_node.animation = 'none'
	if mouse_hovering:
		ring_node.animation = 'open'

func is_occupied() -> bool:
	return is_instance_valid(occupying_character)

func connect_character(character:IntrusionCharacter):
	if can_connect_character(character):
		set_occupying_character(character)

func can_connect_character(character:IntrusionCharacter):
	for connected_node in connected_nodes:
		if connected_node.occupying_character == null:
			continue
		if connected_node.occupying_character.intrusion_id == character.intrusion_id:
			return true
	return false

func connect_node(node:IntrusionNode):
	if connected_nodes.has(node):
		return
	connected_nodes.append(node)

func disconnect_node(node:IntrusionNode):
	var index = connected_nodes.find(node)
	if index >= 0:
		connected_nodes.remove(index)
		
