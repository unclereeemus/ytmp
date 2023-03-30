# eww.dharmx -- https://github.com/dharmx/vile
do `chmod +x mpv_socket_commands ytmpsuite` and move them to your $PATH
also make the scripts under src/scripts executeable but no need to have them in your $PATH

note: this isn't as lean as it could be because these widgets were extracted from a big ecosystem

- only used for ytmp stuff
- but has nice straight forward single bind buttons

- the sliders under the progress bar are: mpv volume, $vol in $run_on_next, and system volume
- the buttons below the sliders: ytmp -l, ytmp -d, ytmp -r, ytmpsuite -tao, ytmpsuite t1, ytmpsuite t2

# eww.gwynsav -- https://github.com/Gwynsav/messydots/
do `chmod +x mpv_socket_commands ytmpsuite` and move them to your $PATH
do `chmod +x mus` and leave it in the same dir as the .yuck and .scss

- is useable for any mpv instance with a socket at /tmp/mpvsocket*
- has many bindings for the same button; can be confusing to navigate

- bottom volume slider: mpv volume

- click on the music icon to change socket or middle click to select socket in dmenu
	or right click for previous socket
- there's too many binds to enumerate so better to go through the config yourself

# NOTE: these configs aren't cleaned up so the naming isn't faithful

# opening the widgets
move them to ~/.config/eww so eww can use them without you having to specify a dir with -c
or do `eww -c eww.dharmx open avatar`
or do `eww -c eww.gwynsav open musicplayer`
optionally start the daemon beforehand with `eww daemon`
