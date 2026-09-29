extends Node

var midi_in : Array[MidiIn]
var midi_out : MidiOut

const OUT_PORT : String = "Godot Virtual Midi 4"
# Called when the node enters the scene tree for the first time.

var note_ensemble : Array[int] = []

signal on_input_note(note : int, velocity : int, released : bool)
signal note_ensemble_changed()

func _ready() -> void:
	print_input_ports()
	print_output_ports()
	
	midi_in = []
	midi_out = MidiOut.new()

func print_input_ports() -> void:
	print("Available Input Ports: --------------------")
	for n : String in MidiIn.get_port_names():
		print("- " + n)
	print("-------------------------------------------\n")
	
func print_output_ports() -> void:
	print("Available Output Ports: -------------------")
	for n : String in MidiOut.get_port_names():
		print("- " + n)
	print("-------------------------------------------\n")
	
func open_virtual_output() -> bool:
	if OUT_PORT in MidiOut.get_port_names():
		midi_out.open_port(MidiOut.get_port_names().find(OUT_PORT))
		return true
		
	else:
		return false
		
func connect_input(port_name : String, forward : bool = true) -> bool:
	# TODO check if already connected
	
	var new_midi_in : MidiIn = MidiIn.new()
	
	if port_name in MidiIn.get_port_names():
		new_midi_in.open_port(MidiIn.get_port_names().find(port_name))
		
		new_midi_in.midi_message.connect(_on_input_message.bind(port_name))
		if forward:
			new_midi_in.midi_message.connect(_forward_message)
		
		midi_in.append(new_midi_in)
		
		return true
	
	return false

@warning_ignore("unused_parameter")
func _on_input_message(_delta : float, message : PackedByteArray, port_name : String) -> void:
	#print("Message " + str(message) + " from port " + port_name)
	if message[0] == 144:
		on_input_note.emit(message[1], message[2], false)
		check_ensemble_change(message[1], false)
	elif message[0] == 128:
		on_input_note.emit(message[1], message[2], true)
		check_ensemble_change(message[1], true)

func check_ensemble_change(note : int, release : bool) -> void:
	if note in note_ensemble and release:
		note_ensemble.remove_at(note_ensemble.find(note))
		note_ensemble_changed.emit()
	
	elif !(note in note_ensemble) and !release:
		note_ensemble.append(note)
		note_ensemble_changed.emit()
	
func _forward_message(_delta : float, message : PackedByteArray) -> void:
	if midi_out.is_port_open():
		midi_out.send_message(message)
