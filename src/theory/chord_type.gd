class_name ChordType
extends Resource

@export var notes : Array[int]

@export var name : StringName

func equals(other : ChordType) -> bool:
	return other.name == name
