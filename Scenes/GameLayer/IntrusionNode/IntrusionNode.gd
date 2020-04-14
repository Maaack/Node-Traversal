tool
extends Node2D


class_name IntrusionNode

signal mouse_entered
signal mouse_exited

var occupied
var occupying_character
var port_route_map = {}
var key_connected_node_map = {}

func _on_Area2D_mouse_entered():
	emit_signal("mouse_entered")
	$AnimatedSprite.animation = 'open'

func _on_Area2D_mouse_exited():
	emit_signal("mouse_exited")
	if occupied:
		$AnimatedSprite.animation = 'closed'
	else:
		$AnimatedSprite.animation = 'none'

func enter_node(character:IntrusionCharacter):
	occupied = true
	occupying_character = character
	$AnimatedSprite.animation = 'closed'

func exit_node():
	occupied = false
	occupying_character = null
	$AnimatedSprite.animation = 'none'

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
