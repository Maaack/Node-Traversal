tool
extends Node2D


class_name IntrusionNode

signal mouse_entered
signal mouse_exited

var occupied
export(Resource) var occupying_character setget set_occupying_character
var port_route_map = {}
var key_connected_node_map = {}

func _on_Area2D_mouse_entered():
	emit_signal("mouse_entered")
	$AnimatedSprite.animation = 'open'

func _on_Area2D_mouse_exited():
	emit_signal("mouse_exited")
	if is_occupied():
		$AnimatedSprite.animation = 'closed'
	else:
		$AnimatedSprite.animation = 'none'

func set_occupying_character(character:IntrusionCharacter):
	occupying_character = character
	if is_occupied():
		$AnimatedSprite.modulate = occupying_character.character_color
		$AnimatedSprite.animation = 'closed'
	else:
		$AnimatedSprite.modulate = Color(1,1,1,1)
		$AnimatedSprite.animation = 'none'
		

func is_occupied() -> bool:
	return is_instance_valid(occupying_character)
	
func enter_node(character:IntrusionCharacter):
	set_occupying_character(character)

func exit_node():
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
