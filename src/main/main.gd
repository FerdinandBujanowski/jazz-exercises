class_name Main extends Node2D

@onready var text: RichTextLabel = $"UI Root/RichTextLabel"
@onready var keyboard: Keyboard = $Keyboard

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	if !MidiHandler.open_virtual_output():
		push_error("Something went wrong when trying to open the virtual midi port.")
		
	if MidiHandler.connect_input(MidiIn.get_port_name(0)):
		print("Successfully connected to MIDI input.")
	
	MidiHandler.on_input_note.connect(keyboard._on_input_note)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
