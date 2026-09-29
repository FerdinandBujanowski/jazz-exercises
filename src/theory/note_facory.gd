extends Node

var notes : Dictionary[int, Array] = {
	0: ["C"],
	1: ["C#", "Db"],
	2: ["D"],
	3: ["D#", "Eb"],
	4: ["E"],
	5: ["F"],
	6: ["F#", "Gb"],
	7: ["G"],
	8: ["G#", "Ab"],
	9: ["A"],
	10: ["A#", "Bb"],
	11: ["B"]
}

var chord_types : Array[ChordType] = []
var chords : Array[Chord]

func _ready() -> void:
	## GENERATE ALL CHORD TYPES
	var maj7_chord_type : ChordType = ChordType.new()
	maj7_chord_type.name = "Maj7"
	maj7_chord_type.notes = [0, 4, 7, 11]
	chord_types.append(maj7_chord_type)

	var min7_chord_type : ChordType = ChordType.new()
	min7_chord_type.name = "m7"
	min7_chord_type.notes = [0, 3, 7, 10]
	chord_types.append(min7_chord_type)
	
	var dom7_chord_type : ChordType = ChordType.new()
	dom7_chord_type.name = "7"
	dom7_chord_type.notes = [0, 4, 7, 10]
	chord_types.append(dom7_chord_type)
	
	var hdim_chord_type : ChordType = ChordType.new()
	hdim_chord_type.name = "m7b5"
	hdim_chord_type.notes = [0, 3, 6, 10]
	chord_types.append(hdim_chord_type)
	
	## GENERATE ALL CHORDS FROM CHORD TYPES
	for root : int in range(12):
		for chord_type : ChordType in chord_types:
			var new_chord : Chord = Chord.new()
			new_chord.root = root
			new_chord.type = chord_type 
			chords.append(new_chord)
			
	## SAVE ALL 2-N-OVERLAPS
	for i in range(chords.size()):
		for j in range(i+1, chords.size()):
			var current_overlap : int = chords.get(i).get_note_overlap_count(chords.get(j))
			
			if current_overlap >= 2:
				chords.get(i).two_note_similarities.append(chords.get(j))
				chords.get(j).two_note_similarities.append(chords.get(i))
	
			if current_overlap >= 3:
				chords.get(i).three_note_similarities.append(chords.get(j))
				chords.get(j).three_note_similarities.append(chords.get(i))
				
	print("Chords very similar to " + str(chords.get(10)) + ": -----------")
	for chord : Chord in chords.get(10).three_note_similarities:
		print("- " + str(chord))
	print("\n")
	
		
func get_note_string(key:int, sharp:bool=true, flat:bool=false):
	if key < 0 or (!sharp and !flat):
		return notes[0][0]
		
	var note_options : Array = notes[key]
	
	if len(note_options) == 1 or (flat and !sharp):
		return note_options[0]
		
	if sharp and flat:
		return note_options[randi()%2]
	
	return note_options[1]
