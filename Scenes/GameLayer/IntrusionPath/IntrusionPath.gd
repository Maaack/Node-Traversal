tool
extends Node2D


class_name IntrusionPath

const ORIENTATION_VECTOR = Vector2(0.0, -1.0)
const ORIGINAL_SCALE = Vector2(1.0, 1.0)

onready var sprite_node = $Sprite

export(NodePath) var target_a_path setget set_target_a_path
export(NodePath) var target_b_path setget set_target_b_path
export(Resource) var occupying_character setget set_occupying_character
export(float) var line_length_offset = -128

var target_a: IntrusionNode
var target_b: IntrusionNode
var original_size: Vector2
var original_length: float

func _process(delta):
	update_line()

func set_target_a_path(value:NodePath):
	if is_instance_valid(target_a):
		disconnect_nodes()
	target_a_path = value
	target_a = get_node_or_null(target_a_path)
	connect_nodes()

func set_target_b_path(value:NodePath):
	if is_instance_valid(target_b):
		disconnect_nodes()
	target_b_path = value
	target_b = get_node_or_null(target_b_path)
	connect_nodes()

func resolve_paths_to_nodes():
	if target_a == null or target_b == null:
		if target_a == null and target_a_path != null:
			target_a = get_node_or_null(target_a_path)
		if target_b == null and target_b_path != null:
			target_b = get_node_or_null(target_b_path)
		connect_nodes()

func update_line() -> void:
	resolve_paths_to_nodes()
	update_occupying_character()
	update_line_position_and_scale()

func update_line_position_and_scale() -> void:
	if target_a == null or target_b == null:
		return
	if not is_instance_valid(sprite_node):
		return
	var delta_vector = target_b.position - target_a.position 
	var delta_rotation = ORIENTATION_VECTOR.angle() + delta_vector.angle()
	sprite_node.rotation = delta_rotation
	position = target_a.position + ( delta_vector / 2 )
	original_size = sprite_node.texture.get_size()
	original_length = max(original_size.x, original_size.y)
	if original_length != null:
		sprite_node.scale.y = ORIGINAL_SCALE.y * ((delta_vector.length() + line_length_offset) / original_length)

func disconnect_nodes() -> void:
	if target_a == null or target_b == null:
		return
	target_a.disconnect_node(target_b)
	target_b.disconnect_node(target_a)

func connect_nodes() -> void:
	if target_a == null or target_b == null:
		return
	target_a.connect_node(target_b)
	target_b.connect_node(target_a)
	
func is_route_to(destination):
	if destination == null:
		return false
	return target_a == destination or target_b == destination

func update_occupying_character() -> void:
	if target_a == null or target_b == null:
		return
	if target_a.occupying_character == target_b.occupying_character:
		set_occupying_character(target_a.occupying_character)
	else:
		set_occupying_character(null)

func set_occupying_character(character:IntrusionCharacter):
	occupying_character = character
	if sprite_node == null:
		return
	if occupying_character != null:
		sprite_node.modulate = character.color
	else:
		sprite_node.modulate = Color(1,1,1,1)
