class_name ChordExercise
extends Control

@onready var chord_text: RichTextLabel = $ChordText
@onready var timer: Timer = $Timer

var selected_chord : Chord
var last_chord : Chord

var chord_similarity : int = 2
var allow_same_root : bool = false

var save_to_file : bool = true
var file_name : String
var start_ticks : int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if save_to_file:
		file_name = Time.get_datetime_string_from_system(true, true).replace(":","-") + ".tsv"
		print("Saving exercise to file " + file_name)
		var file = FileAccess.open("user://" + file_name, FileAccess.WRITE)
		file.store_csv_line(["chord","notes","time"], "\t")
	new_chord()

func new_chord() -> void:
	start_ticks = Time.get_ticks_msec()
	
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
	# get passed time and save to file
	var passed_ticks : int = Time.get_ticks_msec() - start_ticks
	var file = FileAccess.open("user://" + file_name, FileAccess.READ_WRITE)
	file.seek_end()
	file.store_csv_line([str(selected_chord),str(MidiHandler.note_ensemble),str(passed_ticks/1000.)], "\t")
	
	# disconnect signals from old chord
	MidiHandler.note_ensemble_changed.disconnect(selected_chord._check_all_played)
	selected_chord.full_chord_played.disconnect(_on_full_chord_played)
	chord_text.add_theme_color_override("default_color", Color("00a300ff"))
	last_chord = selected_chord
	
	timer.start(0.5)
	await timer.timeout
	
	new_chord()
