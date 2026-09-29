extends Node

var EXTENSION_DICT : Dictionary = {
	"69": "±",
	"m": "Μ",
	"7": "ί",
	"hd": "Ø",
	"dim": "°",
	"9": "α",
	"11": "ΩΩ",
	"Maj": "ª",
	"-": "ε",
	"6": "ή",
	"5": "έ",
	"+": "δ",
	"13": "ΩΫ",
	"b": "β",
	"sus": "ψ",
	"4": "ά"
}

var KEY_DICT : Dictionary = {
	"b": "ь",
	"#": "#"
}

func get_font_string(s:String, d:Dictionary) -> String:
	var current_index : int = 0
	var out:String = ""
	
	while current_index < s.length():
		var slice_found : bool = false
		for l : int in range(1, 4):
			if !slice_found:
				var s_slice : String = s.substr(current_index, l)
				if s_slice in d.keys():
					slice_found = true
					out += d.get(s_slice)
					current_index += l
				
		if !slice_found:
			out += s.substr(current_index, 1)
			current_index += 1
	return out

func get_extension_font_string(ext:String) -> String:
	return get_font_string(ext, EXTENSION_DICT)
	
func get_key_font_string(key:String) -> String:
	return get_font_string(key, KEY_DICT)
