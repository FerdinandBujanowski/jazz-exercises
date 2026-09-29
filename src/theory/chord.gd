class_name Chord
extends Resource

@export var root : int = 0
@export var type : ChordType

var two_note_similarities : Array[Chord] = []
var three_note_similarities : Array[Chord] = []

signal full_chord_played()
	
func get_font_string(sharp:bool=true, flat:bool=false) -> String:
	var key_string = SymbolDict.get_key_font_string(NoteFactory.get_note_string(root, sharp, flat))
	var ext_string = SymbolDict.get_extension_font_string(type.name)
	
	return key_string + ext_string

func get_rooted_notes() -> Array[int]:
	var out : Array[int] = []
	for note in type.notes:
		out.append((note + root) % 12)
		
	return out
	
func get_note_overlap_count(chord : Chord) -> int:
	var overlaps : int = 0
	
	for note : int in get_rooted_notes():
		if note in chord.get_rooted_notes():
			overlaps += 1
			
	return overlaps

func _to_string() -> String:
	return NoteFactory.notes.get(root)[0] + type.name

func _check_all_played(exclusive : bool = true) -> void:
	#print(MidiHandler.note_ensemble)
	var rooted_notes : Array[int] = get_rooted_notes()
	
	for note : int in MidiHandler.note_ensemble:
		if rooted_notes.size() == 0 and exclusive:
			return
			
		if note % 12 in rooted_notes:
			rooted_notes.remove_at(rooted_notes.find(note % 12))
			
	if rooted_notes.size() == 0:
		full_chord_played.emit()
		
func equals(other : Chord) -> bool:
	return other.type.notes == type.notes and other.root == root
