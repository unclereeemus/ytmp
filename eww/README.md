there's a picture for how these look in their folders

requirements:
- install `jq`
- do `chmod +x mpv_socket_commands ytmpsuite` and move them to your $PATH
- you might need to have certain fonts installed, check the repos below;
	i am using nerdfonts(https://www.nerdfonts.com/) for the icons

# eww.dharmx -- https://github.com/dharmx/vile
`chmod +x src/scripts/*`

- only used for ytmp stuff
- but has nice straight forward single bind buttons

- the buttons under the progress bar are: random song, quit song, ytmp vv
- the sliders are: mpv volume, $vol in $run_on_next, and system volume
- the buttons below the sliders: ytmp -l, ytmp -d, ytmp -r, ytmpsuite tao, ytmpsuite t1, ytmpsuite t2

# eww.gwynsav -- https://github.com/Gwynsav/messydots/
`chmod +x mus`

- is useable for any mpv instance with a socket at /tmp/mpvsocket*
- has many bindings for the same button; can be confusing to navigate

- bottom slider: mpv volume

- click on the music icon to change socket or middle click to select socket in dmenu
	or right click for previous socket
- there's too many binds to enumerate so better to go through the config yourself

- optionally `chmod +x ewwvarupd` to immediately update varibles(name, progress...) in eww when switching a socket

# NOTE: these configs aren't cleaned up so the variable names aren't accurately descriptive all the time

# opening the widgets
move them to ~/.config/eww so eww can use them without you having to specify a dir with -c
or do `eww -c eww.dharmx open avatar`
or do `eww -c eww.gwynsav open musicplayer`
optionally start the daemon beforehand with `eww daemon`
