class_name Keyboard
extends Control

@onready var keys: HBoxContainer = $Keys

var key_array : Array[Key] = []

var lowest_note : int = 36

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for child : Node in keys.get_children():
		if child is Key:
			key_array.append(child)
			if child.black:
				child.z_index = 1
				


func _on_input_note(note : int, _velocity : int, released : bool) -> void:
	if note - lowest_note >= key_array.size():
		return
	
	key_array.get(note - lowest_note).play(released)
