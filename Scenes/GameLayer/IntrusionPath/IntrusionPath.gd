tool
extends Node2D


class_name IntrusionPath

const ORIENTATION_VECTOR = Vector2(0.0, -1.0)
const ORIGINAL_SCALE = Vector2(1.0, 1.0)
const LENGTH_OFFSET = -128

onready var cost_node = $Cost
onready var sprite_node = $Sprite

export(NodePath) var target_a_path setget set_target_a_path
export(NodePath) var target_b_path setget set_target_b_path
export(int, 0, 1024) var cost: int = 1 setget set_cost

var target_a: IntrusionNode
var target_b: IntrusionNode
var original_size: Vector2
var original_length: float
var owned
var owning_character

func _process(delta):
	update_line()
	update_text()
	
func set_cost_node(value:Node):
	cost_node = value
	update_text()

func set_sprite_node(value:Node):
	sprite_node = value
	update_line()

func set_target_a_path(value:NodePath):
	target_a_path = value
	update_line()

func set_target_b_path(value:NodePath):
	target_b_path = value
	update_line()

func set_cost(value:int):
	cost = value
	update_text()

func update_text():
	if cost != null and is_instance_valid(cost_node):
		cost_node.text = str(cost)

func resolve_paths_to_nodes():
	target_a = get_node_or_null(target_a_path)
	target_b = get_node_or_null(target_b_path)

func update_line() -> void:
	resolve_paths_to_nodes()
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
		sprite_node.scale = ORIGINAL_SCALE * ((delta_vector.length() + LENGTH_OFFSET) / original_length)

func is_route_to(destination:IntrusionNode):
	if destination == null:
		return false
	return target_a == destination or target_b == destination

func connect_intruder(owner:IntrusionCharacter):
	owned = true
	owning_character = owner

func disconnect_intruder():
	owned = false
	owning_character = null
