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
var port_route_map = {}
var key_connected_node_map = {}

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
		ring_node.modulate = occupying_character.character_color
		ring_node.animation = 'closed'
	else:
		ring_node.modulate = Color(1,1,1,1)
		ring_node.animation = 'none'
	if mouse_hovering:
		ring_node.animation = 'open'


func is_occupied() -> bool:
	return is_instance_valid(occupying_character)

func connect_from(target:IntrusionNode, owner:IntrusionCharacter):
	var route = get_route_to(target)
	if route == null:
		return
	var node_key = target.get_instance_id()
	if key_connected_node_map.has(node_key):
		return true
	route.connect_intruder(owner)
	key_connected_node_map[node_key] = target
	return true

func get_route_to(target:IntrusionNode):
	for port_key in port_route_map:
		var route = port_route_map[port_key]
		if not is_instance_valid(route):
			continue
		if route.has_method("is_route_to") and route.is_route_to(target):
			return route
