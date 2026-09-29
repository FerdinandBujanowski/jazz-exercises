class_name ChordExercise
extends Control

@onready var chord_text: RichTextLabel = $ChordText
@onready var timer: Timer = $Timer

var selected_chord : Chord
var last_chord : Chord

var chord_similarity : int = 2
var allow_same_root : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	new_chord()

func new_chord() -> void:
	if selected_chord == null:
		selected_chord = NoteFactory.chords.pick_random()
		
	else:
		
		# pick new chord based on similarity to old chord
		var new_selection : Array[Chord] = []
		if chord_similarity == 3:
			new_selection = selected_chord.three_note_similarities
		else: # TODO allow for different cases
			new_selection = selected_chord.two_note_similarities
		
		var i : int = 0
		while i < new_selection.size():
			if new_selection[i].root == selected_chord.root and !allow_same_root:
				new_selection.remove_at(i)
			elif new_selection[i].equals(last_chord):
				new_selection.remove_at(i)
			else:
				i += 1
		
		selected_chord = new_selection.pick_random()
		
	# connect signals
	MidiHandler.note_ensemble_changed.connect(selected_chord._check_all_played)
	selected_chord.full_chord_played.connect(_on_full_chord_played)
	
	# update chord text
	chord_text.add_theme_color_override("default_color", Color("black"))
	chord_text.text = selected_chord.get_font_string(true, true)

func _on_full_chord_played() -> void:
	# disconnect signals from old chord
	MidiHandler.note_ensemble_changed.disconnect(selected_chord._check_all_played)
	selected_chord.full_chord_played.disconnect(_on_full_chord_played)
	chord_text.add_theme_color_override("default_color", Color("00a300ff"))
	last_chord = selected_chord
	
	timer.start(0.5)
	await timer.timeout
	
	new_chord()
