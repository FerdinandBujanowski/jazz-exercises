# jazz-exercises
Open-source Godot project with Jazz / music theory exercises that can be done with a MIDI controller / keyboard.

The reason why I use Godot for this is that its interface and existing UI classes allow for quick and uncomplicated creation of graphics that respond to underlying music theory / MIDI logic. In addition, Godot's system of _signals_ (i.e. their implementation of the "observer" pattern) make the future creation / modification of exercises quite easy and scalable. 

# How to use
todo explain how to use :)

# Work from other people
* This godot project uses the godot-rtmidi extension (https://github.com/NullMember/godot-rtmidi)
* I also use Tobias Erichsen's "loopMIDI" application (https://www.tobias-erichsen.de/software/loopmidi.html) to create a virtual midi port to reroute MIDI signals (so that input can both be read by Godot and trigger sound through a DAW / other software)
* The _Real Book_ jazz chord font can be found here: https://github.com/vinzentt/jazz-lead-sheet/tree/master. It was originally created for an in-browser lead sheet editor (https://guitarejazzmanouche.com/grilles/add/), which is also where I found all the characters that, with the jazz font, translate to your typical jazz chord extension symbols.
