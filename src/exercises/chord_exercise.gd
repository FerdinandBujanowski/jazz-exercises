class_name ChordExercise
extends Control

@onready var chord_text: RichTextLabel = $ChordText
@onready var exercise_timer: Timer = $Timer

var paused : bool = false

var selected_chord : Chord
var last_chord : Chord

var chord_similarity : int = 2
var allow_same_root : bool = false

var save_to_file : bool = true
var file_name : String
var start_ticks : int = 0

var time_between_trials : float = 0.75

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pause_exercise()
	$PauseButton.pressed.connect(pause_exercise)

func pause_exercise() -> void:
	if paused:
		return
		
	paused = true
	chord_text.text = "Press key to start.."
	MidiHandler.on_input_note.connect(_on_key_pressed)
	
	if selected_chord != null:
		# disconnect signals from old chord
		MidiHandler.note_ensemble_changed.disconnect(selected_chord._check_all_played)
		selected_chord.full_chord_played.disconnect(_on_full_chord_played)
	
func _on_key_pressed(_note : int, _velocity : int, _released : bool):
		if paused:
			paused = false
			start_exercise()
	
func start_exercise() -> void:
	MidiHandler.on_input_note.disconnect(_on_key_pressed)
	
	if save_to_file:
		file_name = Time.get_datetime_string_from_system(true, true).replace(":","-") + ".tsv"
		print("Saving exercise to file " + file_name)
		var file = FileAccess.open("user://chord_exercise/" + file_name, FileAccess.WRITE)
		file.store_csv_line(["chord","notes","time"], "\t")
	
	new_chord()
	
func new_chord() -> void:
	start_ticks = Time.get_ticks_msec()

	selected_chord = NoteFactory.get_new_chord(
		selected_chord, [last_chord],
		get_root_array(),
		get_type_array(),
		1, 3 # TODO implement algorithm
	)

	# connect signals
	MidiHandler.note_ensemble_changed.connect(selected_chord._check_all_played)
	selected_chord.full_chord_played.connect(_on_full_chord_played)
	
	# update chord text
	chord_text.add_theme_color_override("default_color", Color("black"))
	chord_text.text = selected_chord.get_font_string(
			$SharpFlatGrid/sharp_box.button_pressed,
			$SharpFlatGrid/flat_box.button_pressed
	)

func get_root_array() -> Array[int]:
	var roots : Array[int] = []
	
	for i in range(12):
		var current_child : CheckBox = $NoteGrid.get_child(i) as CheckBox
		if current_child != null and current_child.button_pressed:
			roots.append(i)
	
	return roots
	
func get_type_array() -> Array[ChordType]:
	var types : Array[ChordType] = []
	
	for i in range($ChordTypeGrid.get_child_count()):
		var current_child : CheckBox = $ChordTypeGrid.get_child(i) as CheckBox
		if current_child != null and current_child.button_pressed:
			types.append(NoteFactory.chord_types[i])
	
	return types
	
func _on_full_chord_played() -> void:
	# get passed time and save to file
	var passed_ticks : int = Time.get_ticks_msec() - start_ticks
	var file = FileAccess.open("user://chord_exercise/" + file_name, FileAccess.READ_WRITE)
	file.seek_end()
	file.store_csv_line([str(selected_chord),str(MidiHandler.note_ensemble),str(passed_ticks/1000.)], "\t")
	
	# disconnect signals from old chord
	MidiHandler.note_ensemble_changed.disconnect(selected_chord._check_all_played)
	selected_chord.full_chord_played.disconnect(_on_full_chord_played)
	
	chord_text.add_theme_color_override("default_color", Color("00a300ff"))
	last_chord = selected_chord
	
	exercise_timer.start(time_between_trials)
	await exercise_timer.timeout
	
	new_chord()
