# jazz-exercises
Open-source Godot project with Jazz / music theory exercises that can be done with a MIDI controller / keyboard.

The reason why I use Godot for this is that its interface and existing UI classes allow for quick and uncomplicated creation of graphics that respond to underlying music theory / MIDI logic. In addition, Godot's system of _signals_ (i.e. their implementation of the "observer" pattern) make the future creation / modification of exercises quite easy and scalable. 

# How to use
todo explain how to use :)

# User Data
When performing exercises, relevant data (regarding the nature of each individual 'trial' of the given exercise, as well as 'reaction' / completion time of each trial) can be saved into .tsv files, which can be used if you want to track your performance / improvement over time. By default (at least on Windows, not sure for Mac, Linux etc), Godot saves user data in the `%appdata%/Godot/app_userdata/` directory.

# Work from other people
* This godot project uses the godot-rtmidi extension (https://github.com/NullMember/godot-rtmidi)
* I also use Tobias Erichsen's "loopMIDI" application (https://www.tobias-erichsen.de/software/loopmidi.html) to create a virtual midi port to reroute MIDI signals (so that input can both be read by Godot and trigger sound through a DAW / other software)
* The _Real Book_ jazz chord font can be found here: https://github.com/vinzentt/jazz-lead-sheet/tree/master. It was originally created for an in-browser lead sheet editor (https://guitarejazzmanouche.com/grilles/add/), which is also where I found all the characters that, with the jazz font, translate to your typical jazz chord extension symbols.
* And of course, you'll need Godot Engine to launch this project: https://godotengine.org/
