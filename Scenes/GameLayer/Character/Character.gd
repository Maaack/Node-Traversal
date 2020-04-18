tool
extends Resource


class_name IntrusionCharacter

export(String) var character_name setget set_character_name
export(Color) var character_color setget set_character_color

func set_character_name(value:String):
	character_name = value

func set_character_color(value:Color):
	character_color = value
