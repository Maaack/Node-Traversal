tool
extends IntrusionCharacter


func move(destination:IntrusionNode):
	if is_instance_valid(occupying_node) and occupying_node is IntrusionNode:
		occupying_node.exit_node()
	destination.enter_node(self)
	occupying_node = destination
