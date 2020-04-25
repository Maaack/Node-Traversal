tool
extends IntrusionNode


class_name DestinationNode

signal destination_reached

func set_occupying_character(character:IntrusionCharacter):
	.set_occupying_character(character)
	if character == null:
		return
	emit_signal("destination_reached", character, self)
