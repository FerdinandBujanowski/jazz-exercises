class_name Key
extends Control

@export var black : bool = false

@onready var panel: Panel = $Panel

var original_key_stylebox : StyleBox
var played_key_stylebox : StyleBox

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if black:
		original_key_stylebox = ResourceLoader.load("uid://coqcf17wbeyi6") as StyleBox
		
		custom_minimum_size.x = 0
		panel.position.x = -15
		panel.size = Vector2i(30, 140)
		#custom_minimum_size.x = 1
		#panel.custom_minimum_size = Vector2i(1, 120)
		#panel.size = panel.custom_minimum_size
		#custom_minimum_size = panel.custom_minimum_size
		#size = custom_minimum_size
		
		if original_key_stylebox != null:
			panel.add_theme_stylebox_override("panel", original_key_stylebox)
		else:
			push_error("Couldn't load black key stylebox as such.")
	else:
		original_key_stylebox = ResourceLoader.load("uid://bso3wl2u52pqs") as StyleBox
		
	played_key_stylebox = ResourceLoader.load("uid://c5l210gegedv7") as StyleBox
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func play(release : bool) -> void:
	if release:
		panel.add_theme_stylebox_override("panel", original_key_stylebox)
	else:
		panel.add_theme_stylebox_override("panel", played_key_stylebox)
