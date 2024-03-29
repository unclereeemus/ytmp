# ytmp
a shell script for searching, playing, downloading, and keeping track of music from youtube and local files with extensive queue management using fzf, vim, or cli

demo: https://www.reddit.com/r/unixporn/comments/11mxwb0/oc_i_wrote_a_cli_and_keyboard_centric/

**FEATURES:**
  - CLI/keyboard centered
  - Add local files/directories
  - Search regular youtube or youtube music (in a round about way - see usage for explanation)
  - Select from search results
  - Search and add youtube playlists to the queue (or only select songs of playlists)
  - Select from past searches in fzf to reduce typing
  - Download songs after they have been played a chosen amount of times (and play the download in the future)
  - FZF preview of song/playlist details
  - Manage the queue from fzf, vim, cli
  - Keep track of listen history/amount
  - Run commands on song start
  - Specify a queue order to iterate through without having to shift entries in the queue file (see usage for -d)
  - Tag songs
  - Communicate with mpv through its ipc socket
  - Everything is a plain text file
  - (termux/ytmp: specify volume/queue/mpv args from cli or per song mpv settings with tags)

# setup
## DEPS: fzf, yt-dlp, mpv, socat, gnu coreutils, dash/posix compatible shell, (for playlist search - pipe-viewer(https://github.com/trizen/pipe-viewer/)) -- only tested on a GNU/Linux system
## NOT A DEP: accounts of any sort
`git clone --depth 1 'https://github.com/unclereeemus/ytmp/'; cd ytmp; chmod +x ytmp run_on_next`

(link/move ytmp to your $PATH like) `[ln -s|mv] $(pwd)/ytmp /home/$USER/.local/bin/`

(if intending to use nvim('E' option)) `mv ytmp.vim ~/.config/nvim/`

move run_on_next to ~/Music/ytmp/ where it's looked for by default; if you move it elsewhere,
change the location in the conf file which is also sourced from ~/Music/ytmp/ by default
(change conf path in source if necessary)

lastly, make sure mpv has the proper yt-dlp path in your mpv rc by setting `script-opts=ytdl_hook-ytdl_path=<YTDLP_PATH>`

the mpv ipc socket is opened at /tmp/mpvsocketytmp

## on first run

on first installing ytmp, there won't be any history to select from when you enter ytmp so either pass arguements from the cli with `ytmp [z] <search>` or to search what's on the fzf input field press ctrl-x or to background search press ctrl-s / ctrl-z (difference explained in `ytmp h`)

# scripts

**ytmp** main script; none of the other scripts need to be set up to get it working.

**conf** for setting ytmp variables/directories. looked for in ~/Music/ytmp/ by default.

**run_on_next** runs at the start of every song which can be used to keep some consistent settings within mpv (volume, loop, seek, etc). looked for in ~/Music/ytmp/ by default.

**ytmp.vim** a vim config with useful keybinds relevant to ytmp

**ytmpsuite** for oneliners or automation of things like toggling lines in run_on_next, selecting queues, creating playlists; some of the lines under 'tips' can be found there as well. there is no help option so you'll have to parse through the code and comments to figure out what does what if you want to use it.

**ytmp.gum** a wrapper for mpv/ytmp/ytmpsuite to control playback/toggle things in run_on_next and ytmp. there are two modes for this; one is a status line showing currently playing, what's before and after currently playing, and whether certain things are toggled for mpv/ytmp/ytmpsuite and optionally showing ascii/ansi art - utilizes gum (https://github.com/charmbracelet/gum); another where said certain things are toggled in an fzf menu (would recommend looking through the source for binds).

**mightfinduseful** a script to play music outside of ytmp either with local files, youtube search, or the ytmp queue file. also dynamically names the mpvsocket so you don't overwrite an old one.

**mpv_socket_commands** wrapper for communicating with an mpv socket (see -h)

**eww/** contain two eww (https://github.com/elkowar/eww) music widgets. see the readme in it to learn more and see pictures.

**termux/** this program ported to termux with some new features not in the linux version (because i am too lazy to maintain two files; if you want to try out the new features/termux version, the script should just work for linux just makes sure to change the $prefix in the script; notably the -v and -q option allowing one to specify the queue and volume from the cli and -mpv to pass args to mpv or set per song mpv settings using <MPV:> tag. also songs selected to be (from fzf with | or enter; not true for -d or e) played are moved to a temporary queue and the daemon can be started right from fzf. readme mentions notable changes.

# tips
- a dmenu wrapper: `cmd="$( printf ' ' | dmenu -p 'which ytmp cmd to run? ' )" && if ( printf "$cmd" | grep -Eq '^( |x.*|s.*|z|l s|v|vv|E|sp.*)+$' ); then setsid -f $TERMINAL -e ytmp $cmd >/dev/null 2>&1; else ytmp $cmd; fi`

- play dmenu selection: `cat "/home/$USER/Music/ytmp/queue" | dmenu -l 15 | cut -d' ' -f1 | xargs -I ,, ytmp P -id ,,`

- you don't need to use ytmp to make playlists for it. to create a queue file from a youtube playlist you can do `yt-dlp --print id --print title '<playlist_url>' | paste -s -d ' \n' > file` or to create a queue file from search results do `xargs -d '\n' -a <file-with-newline-sperated-searches> -I ,, yt-dlp --print id --print title ytsearch:",," | paste -s -d ' \n' > file` (to read from stdin instead of a file use `printf '%s\n' '<search1>' '<search2>' '<search3>' | xargs [without -a option]...`) or to search for playlists from the terminal (requires pipe-viewer): `search='YOUR_SEARCH'; pipe-viewer --no-interactive -sp --custom-playlist-layout='*VIDEOS*VIDS *TITLE* *URL*' "$search" | fzf --bind='ctrl-a:execute(echo {} | awk "{print $NF}" | xargs -0 -I ",," pipe-viewer --custom-layout="*AUTHOR* *TIME* *TITLE*" --no-interactive ",," | fzf)' | awk '{print $NF}' | xargs -0 -I ',,' yt-dlp --print id --print title ',,' | paste -s -d ' \n' > file` (have a look at `ytmpsuite sp` for a more featureful version with previews and individual song select or `ytmpsuite pvpl` to automate playlist search and add or `ytmpsuite scrape` to scrape lists from rym, aoty, discogs)

- convert spotify playlists to something ytmp can use: export the playlist to csv with https://github.com/watsonbox/exportify then run `cut -d'"' --output-delimiter=' ' -f4,8 PLAYLIST.CSV | sed 1d | tr -d '()[]' | xargs -d '\n' -I ',,' yt-dlp --print id --print title ytsearch1:",," | paste -s -d ' \n' > file`

- play queue backwards: `while (ytmp -n); do ytmp p; done`

- to sort your play history by how many times you've listened to something use `sort -nk2 "/home/$USER/Music/ytmp/played_urls" | less`

- if you wanted to use this for videos instead of music, do a global remove of `--vid=no` and a global replace of `--ytdl-format='bestaudio'` with your preference of video and audio quality (like `--ytdl-format=bestvideo'[height<=?1080]'+bestaudio`) in the source. further, you could also display the covert art/always pop an mpv window open on the start of each song by doing a global replace of `--vid=no` with `--cover-art-file="$thumbnail_ln"` (having set `download_thumbnails='y'` in the conf of course).

- if you want one less dependancy (socat), remove the line `echo quit | socat - "$mpvsocket" >/dev/null 2>&1` from `play ()` and replace it with `pkill -f "mpv.*--input-ipc-server=${mpvsocket}"` though that will mean that anything that's got to do with mpv/playback control will not work. fzf can also be considered an optional dep because the cli covers everything except result select.

- you can make a scratchpad (i recommend tdrop(https://github.com/noctuid/tdrop) if your wm doesn't support them) of `ytmp E` which can be your one stop for music management (you can invoke ytmp with keybindings by using the vim config provided)

# credit
- this is a fork of the now deleted repo ifeelalright1970/ytmp with additional features and bug fixes
- https://github.com/dharmx/vile for eww config
- https://github.com/Gwynsav/messydots for eww config

# usage
```
Usage: ytmp [-i #] [a|z|x|s|ps|sp] [-f|-fc] [[-t]|[--tag <'alt'|tags>]] [[--startwith] <search>]/e #
         OR v/ls [# [#]]/m [[c] [r] [# ... #]] [[c] x [x] #] [s [#]]/-m [[c] [r] ...]/E
         OR -l/-p/-ff|-bb [#]/-vl [[+|-]#]/-dur OR n/p/pl/pf/mln/mfn/l [#|s]/P <search>
	 OR N [-r] <search|entry>/-r [#,#]/-d [[[+]#[,#] [L]] #...[k]]]

On first installing ytmp, there won't be any history to select from when you enter ytmp
so either pass arguements from the cli with ytmp [z] <search> or to search what's on the
fzf input field press ctrl-x or to background search press ctrl-s / ctrl-z
(difference explained below)

The difference between s and x/z: x/z searches without the added jargon 'auto-generated
provided to youtube' which usually fetches results from youtube music. If you just pass
the query from the command line or just run ytmp without options, it will add the jargon
to your search. ytmp and ytmp z also accept arguements as search if you don't want to
enter fzf for search.

  [no arg] 	enter fzf to make a search with the jargon appended.
  [<search>] 	search with the jargon.
  z [<search>] 	search without the jargon. if no args then enter fzf.

  s [<# of results>] [<search>]
  		search with the jargon. view search results and select (can select multiple).
		can specify count of search results to return with the first arguement (no flag)
		- defaults to \$def_res_count($def_res_count).

  x [<# of results>] [<search>]
  		search without the jargon. view search results and select (can select multiple).
		can specify count of search results to return with the first arguement (no flag)
		- defaults to \$def_res_count($def_res_count).

  sp [<search>] search for playlists (requires https://github.com/trizen/pipe-viewer/)

  ps <playlist url> [-pv]
  		select songs from playlist url to add to queue. a '-pv' can follow the url
		to indicate the program should use pipe-viewer to retrieve the playlist which
		is faster than yt-dlp but does not return all the songs in a playlist.

  a <local path|dir|url> ...
	        add urls (direct links/playlists), paths, or directory. send absolute paths.
		does not check if file is a media file or not before adding.

  * the above options take the following flags: '[-f|-fc] [[-t]|--tag <'alt'|tag ...>] [--startwith search]'
		-f: force add entry meaning if the song is already found in the queue delete the entry that already exists
		      in the queue and add it again (ensuring any new tags are added as well).
		-fc: don't bother deleting the old entry, just add the new entry.
		-t: append \$tags to entry.
		--tag <'alt'|tag ...>: define \$tags to append (no need to pass '-t' before)
			if 'alt' is passed use \$alt_tags instead of \$tags
		--startwith: start fzf with the search string (not available for 'ps' and 'a')

    the default tag is "$tags".

    tags are sent unmodified to yt-dlp --print when it's a song from youtube and a tag contains '%(.*)s' so anything yt-dlp
    --print accepts is good if the pattern is not found, the tag is just added. if yt-dlp returns NA for a field then
    the tag containing the field is not added.

  * further, the search options themselves may be preceeded by '-i #' to specify a destination to add to.
    whether songs are already in the queue is not checked for so this may lead to duplicates of entries.

    when '-i #' or '--tag' is passed for 'sp', the individual songs selected in playlists inherit the position to
    add to and the tags and they are only added to the queue when the playlist selections are finalized or cancelled.

    in sum, the syntax is: ytmp [-i #] [a|z|x|s|ps|sp] [-f|-fc] [[-t]|[--tag tag]] [[--startwith] search]
    when it's [no arg], just pass the flags (like ex 2)

    ex: ytmp x --tag '<tag: 1> <tag: 2>' 10 search
        ytmp --tag alt --startwith search
        ytmp -f -t search
        ytmp -i 2 s search
        ytmp -i p sp -t search

  -af [#] ...	add entries to $favorites_file. if no arg, print $favorites_file.

  e 		play entry #
  n 		play next song
  p 		play prev song
  pf 		play first entry
  pl 		play last entry
  mfn 		move first entry to after currently playing
  mln 		move last entry to after currently playing
  P [-id] <search>
  		fuzzy search string in queue and play match. if -id is passed <search> is parsed for
		in ids too otherwise only in song titles.

  -ff [<secs>]	seek forward <seconds>; if no arg then use \$def_seek_secs($def_seek_secs)
  -bb [<secs>]	seek backward <seconds>; if no arg then use \$def_seek_secs($def_seek_secs)
  -dur		get the position and duration of song
  -vl [[+|-]#]	set volume. can be an absolute number or <+|-># to current volume. if no arg, print volume.
  			(as in -vl +30, -vl -30, -vl 80)
  -p 		toggle playback
  -l 		toggle loop
  w 		toggle mpv window. don't close the window because that will quit
  		the song as well instead run ytmp w again to close it.

  v 		view queue in fzf
  vv 		view queue with fzf preview of details about the song

  l [#|s] 	play the song that was played before this one or # before this one or
		pass s to select from the history file with fzf; the format of the file
		is <id> <times played> <last played> <'dl' (if downloaded)> <name>
		* fzf bindings: ctrl-j: jump; ctrl-o: open entry in web browser.

  ls [# [#]]	show a numbered list of the queue. optionally accepts two args - one for focusing on a certain
  		# on the queue and another for how much of the surrounding queue to print. if no second arg,
		default is 2.
		ex: ytmp ls p 5 (to print the 5 entries above and below currently playing)

  m [[c] [r] [[[p|l|m[+|-#]]|[#]][,][[p|l|m[+|-#]]|[#]]] ... ] [[c] x [x] # [s [#]]
  		move, copy, remove entries. there are three variables containing three positions:
			l = last
			p = currently playing
			m = a position mark

		- set mark by passing s # and see current mark with just s.

		- pass r to remove, c to copy as the first arg.

		- pass x # to move # to the position of the queue selected in the fzf window
		that will pop up or send a following 'x' (and a position) to move the selection made
		in fzf to the position passed from cli; preceed (first, if there's two) x with 'c' to copy.

		- for c|m|r - can specify a range and multiple args by passing from,to
		(separated by comma). you can use p|l|m for all of 'm c|s|x|r'. further, the <end> or the
		<destination> can be +|-# which means the program will add/subtract that number from the
		<from> or <target> to come up with the <destination>.

		* examples: ytmp m 10 2; ytmp m s 126; ytmp m m +5; ytmp m p+3 l-1; ytmp [c] x [x] p-2;
		ytmp m r p+2,l-15 l-5 10; ytmp m [c] p,+5 10 l 3 5 6 +2; ytmp m [c] 20,24 10 37,33 5 6 +2
		syntax for ytmp m|m c|m r is [<target>|<from>,<to>] <destination> ...

		* if the first number in a range is greater than the second then move range
			bottom up so the order is reversed. ex: ytmp m 10,5 3 => 3,10,9,8...

  c ...		alternative to m c
  r ...		alternative to m r
  M ...		alternative to m s

  -m [c] [r] [# #,# ... <dest>]
  		batch move/copy (with c arg)/remove (with r arg)

		- if entry numbers are passed as args - move/copy all entries to the position of the last arg
		except when 'r' is passed in which case just remove the args
		accepts the same kind of args as 'm'

		- if no args are passed - make selections in an fzf window that will pop up then move/copy
		those selections to after the selection made in a new fzf window that will pop up
		except when 'r' is passed in which case just remove the selections

		* fzf bindings: tab: toggle selection; shift-tab: deselect-all; ctrl-j:jump

		* entries are moved in the order they are selected or the order of the args sent

		* if the first number in a range is greater than the second then move range
			bottom up so the order is reversed. ex: ytmp -m 10,5 3 => 3,10,9,8...

  -c ...	alternative to -m c
  -R ...	alternative to -m r

  E 		open the queue in nvim and source rc from "$XDG_CONFIG_HOME/nvim/ytmp.vim". nvim is started
		with "--noplugin +/'***'" as well.

  -sd <#> [-b] 	get listen history and other details about entry and its youtube
  			description unless '-b' follows # in which case just print the listen history.
  -dl <#> ...	download song #. does not respect \$max_len_for_dl.
  -op <#> ...	open entry in web browser
  -shuf 	runs \`shuf\` on the queue file and overwrites it. the original queue can be found in
  		"$cache_dir/queue_noshuf".

  -vd 		prints "$qdiscards_file" which contains a list of songs that were selected to
  		be added to the queue in the last search/'a' but were already found in the queue.
		it's removed with every search/'a'.

  -rd [c] 	copies or moves songs listed in $cache_dir/ytmpqdiscards; can be copied (when given c option)
  		to or moved (when no options are given) from their current position to the position they
		would have been added to if they were never found on the queue.

  -d [-c|-C] [+#] [<start on>] [[[<from>],[<to>]] [L]] [<from>],[<to>] [#] ... [k]]
		options:
		-c - cycle queue (start playing from the top once queue reaches the end)
		-C - don't cycle queue (default)

		args:
  		no arg - play one song after another

		+# - play # of songs after what's currently playing and quit

  		single arg - start playing from <arg> (if another song is playing, it will wait
			for it to end to start playing from the entry provided.)

		single range - loop in the range if 'L' is passed as following arg
			otherwise exit once done.

		many entries/ranges - play entries/ranges in the order they are sent
			if 'k' is the last arg then exit once all entries are played
			otherwise continue playing from last arg unless last arg is a range

		you can specfiy many ranges, entries, effectively queueing things up to play
		without moving them in the queue file.

		* ranges must be comma separated

		* if you happen to play something outside of the current range,
		the program will pick up from where you left off when you left the range.
		but if you play something inside the range, it will continue on playing from there.

		* the entries specfied are not copied somewhere and played from there so if you
		make changes to the queue, the program will play the entry that's there now
		instead of what was there before the change.

		* accepts args like 'm'

		examples: ytmp -d 4 (start playing from entry four); ytmp -d +4 (play four more songs and quit)
			  ytmp -d 4 25,+7 38 110,112 (play entry 4, 25-32, 38, 110-112 and quit)
			  ytmp -d 4 25,+7 113 (play entry 4, 25-32, and go on playing from 113)
			  ytmp -d 4 25,+7 113 k (play entry 4, 25-32, 113 and quit)
			  ytmp -d 25,+7 L (loop in 25-32)

		(kills any other instances of -r or -d running on start.)

  -r [[<from>],[<to>]]
  		play random entries; a range to play from can be specified with a comma-separated arguement.
  		there's no way to remove the range; if you want it to play beyond it,
		run it again. (kills any other instances of -r or -d running on start.)

  N [-r] <search|entry> ...
  		accepts args acceptable for 'P' and 'e'. plays the songs in the order the args are sent
		one after another. starts playing after current song ends if there is a song playing.
		if the first arg is '-r' then once all the args have been played play
		the next thing after what was playing before 'N' was run (useful for '-d' trailings).
		example: ytmp N -r '<search 1>' <p+5> <search2> <80> p will play the fuzzy match
		for 'search 1' then 5 ahead of that match then the match for search2 then entry 74 then entry 73
		and then entry 6 (assuming entry 5 was playing before 'N' was run)
		* if a 'p' or 'n' is sent (without +|-#), it will be interpreted as ytmp n|p.

  -n 		get notified when mpv exits (i.e. song finishes) except when it quits because the
  			user changes songs

  -N 		get notified when mpv exits (i.e. song finishes) even when it quits because the
  			user changes songs

  -qa 		quit audio
  -kd 		kill daemon (-d)
  -kr 		kill the random daemon (-r)
  -kdr 		kill both -d and -r
  -ka 		do all of the above

  h|help|-h|--help
  		show this help

  * any option that takes an entry for a an arg accepts args like 'm' meaning it will accept
		anything like 'p+4' or if ranges are also accepted then something like 'm,+2' as well.
    these options accept such args: e, -af, ls, m, -m, -sd, -op, -dl, -d, N

  * a '...' indicates option accepts multiple args

  * <search> with spaces don't have to be quoted (except for'N')

  ------------------------------------------------------
  fzf bindings when making search (for ytmp [z|x|s|sp]):
  ------------------------------------------------------

  	ctrl-r		replace input field with entry
  	ctrl-g		search query and selection
  	ctrl-x		send input field as search (none of the selections are passed)
  	ctrl-j		jump
	ctrl-o		open entry in web browser
	ctrl-/		turn query into an entry one can select
	shift-left	delete search from history
  	enter		search only the selections (query not included)
  	ctrl-c/esc	quit

	* the following do background searches; there isn't any indication that the search
	  has passed through so you can assume the fact and just abort fzf when done.

	ctrl-s		search query
	alt-s		search query and selection
	ctrl-z		search query with ytmp z
	alt-z		search query and selection with ytmp z

  -----------------------------------------------------------
  fzf bindings for selecting songs(x|s|ps) and playlists(sp):
  -----------------------------------------------------------

	tab		toggle selection
	shift-tab	deselect all
	enter		add selected entries to queue
  	ctrl-j		jump
	ctrl-o		open entry in web browser

	* sp only:
	ctrl-x		see songs in the playlist; one can select
			songs in the playlist to add with
			<tab> and press <enter> to add them
			the above binds are also valid

  --------------------------------------
  fzf bindings for viewing queue (v|vv):
  --------------------------------------

	home		first and reload
	end		last and reload
	shift-up	move entry up one
	shift-down	move entry down one
	shift-right	play entry and don't quit fzf
	shift-left	remove entry
	right		move entry to after currently playing
	left		move entry to before currently playing
	return		play entry and quit fzf
	alt-m		ytmp m
	ctrl-alt-b	ytmp -m
	ctrl-\		ytmp E
	ctrl-6		ytmp mln
	ctrl-l		move last entry to after current entry
	ctrl-t		move entry to mark
	ctrl-]		ytmp w
	alt-v		up one page
	ctrl-v		down one page
	ctrl-alt-p	up half page
	ctrl-alt-n	down half page
	left-click	play entry
	right-click	move entry to after currently playing
	ctrl-j		jump
	ctrl-s		search query in background
	ctrl-z		search query in background with ytmp z
	ctrl-r		replace input field with entry
	ctrl-alt-f	-af ('favorite') entry
	ctrl-alt-d	download selection
	ctrl-alt-j	jump to currently playing
	alt-j		jump to mark (does not update with mark change)
	alt-r		reload queue
	ctrl-o		open entry in web browser
	alt-up		move entry to first
	alt-down	move entry to last
	>		play next song
	<		play prev song
	ctrl-alt-m	set entry as mark (for 'm' option)
	ctrl-space	ytmp m x for entry
	alt-space	ytmp m x x for entry
	alt-bspace	ytmp m c x for entry
	alt-c		ytmp m c x x for entry
	alt-s		run ytmp and inherit the input field
	alt-z		run ytmp z and inherit the input field
	ctrl-alt-s	run ytmp s and inherit the input field
	ctrl-alt-x	run ytmp x and inherit the input field
	alt-p		run ytmp sp and inherit the input field

  * readline binds are also available in all fzf instances

  -------------------------------------------------------------------------------
  nvim key bindings:
  -------------------------------------------------------------------------------

	leader = 	'\'
	leader-v 	source $XDG_CONFIG_HOME/nvim/init.vim
	leader-s 	source $XDG_CONFIG_HOME/nvim/ytmp.vim
	leader-c 	edit $XDG_CONFIG_HOME/nvim/ytmp.vim
	leader-n 	edit $HOME/Music/ytmp/run_on_next

	up 		move entry up 1
	down 		move entry down 1
	left 		move entry right before currently playing
	right 		move entry right next to currently playing
	shift-up 	move last entry right before currently playing
	shift-down 	move last entry right after currently playing
	shift-right 	move entry to the end
	shift-left 	move entry to the start
	enter 		play entry

	d 		delete line
	r 		reload file
	R 		remove *** from line
	W 		write file
	J 		go to currently playing
	> 		play next
	< 		play previous
	. 		-sd for entry
	o 		open entry in web browser

	ctrl-t 		:te
	ctrl-y 		:te ytmp
	ctrl-w 		:te ytmp z
	ctrl-s 		:te ytmp v
	ctrl-v 		:te ytmp vv
	ctrl-n 		:silent !ytmp N

	leader-v 	change the value of the \$vol var in the run_on_next file
	leader-l 	set volume of what's currently playing
	leader-w 	ytmp w
	leader-y 	:silent !ytmp

  -------------------------------------------------------------------------------

Other features:
  - by default ytmp downloads songs after you have listened to them $max_stream_amount times, if you
  	don't want this feature set \$download_songs to 'n' in $conf. if you want to download every song
	and never stream them set \$max_stream_amount to '1'. the downloads can be found in $songs_dir.
  - any line in the queue that's not <id|checksum (a word of 11 or 12 chars)> <name> is ignored by the program
	so such lines can be considered a comment but for robustness in case your comment happens to
	begin with an 11 or 12 letter word, it's best to begin it with a comment character and space like '# '.
	further, tag entries by adding '<tag>' to the end of the entry (including the '<>'). add as many
	as you like but put a space after the title and first tag. the program only looks for '<' and
	ignores the rest of the entry so the closing '>' is not necessary.
  - one can communicate with mpv through the ipc socket the script opens at $mpvsocket.
  	See https://pastebin.com/23PXxpiD for examples (make sure to pass commands to the
	$mpvsocket socket) and \`mpv --list-properties\` for properties that can be controlled.
  - put commands you want to run at the start of each song in the script $run_on_next.
  - you can have multiple entries of the same song in multiple places and the program won't mind
  	(in case you wanted to move tracks of albums around without changing their place in the album).

You might be interested to know:
  - if you want something to blame the slowness of adding songs/playlists:
  	it is because yt-dlp is slow to retrieve things.
  - the editor config is made for nvim; not all binds are tested to be working in vim
  - get the name of what's currently playing: \`sed "s/^\(.\{11,12\}\) \($playing_ind\)\(.*\)\($closing_playing_ind\)\( *$tag_char.*\)\?$/\3/" "$queue" \` or \`echo '{ "command": ["get_property_string", "media-title" ] }' | socat - "$mpvsocket" | cut -d'"' -f4 | sed -E -e 's/^\([^ ]\{11\}\) //' -e 's/\.webm$//'\`
  - songs are streamed/downloaded with the 'bestaudio' option
  - song/thumbnail downloads are named as "<id> <title>.<ext>"
  - mpv is started with these options: --x11-name='ytmp_mpv' --no-terminal --vid=no --input-ipc-server=$mpvsocket
  	--ytdl-format='bestaudio'
  - when using the 'P' option, the word 'remastered' is not matched
  - when allowed to multi-select in fzf, if no selections are made and enter is pressed, the entry under
  	the cursor is sent; if selections are made and enter is pressed, only the selections are passed
  - entries for local files are created with \`cksum --untagged --algorithm=blake2b -l 48 <file> | sed 's@  @ @'\`
  - thumbnails are not automatically deleted. if \$download_thumbnails option is set to 1 then thumbnails are
	downloaded and not removed regardless of whether the song is downloaded or not
  - move functions are made last to first this is to insure that if multiple entries are competing for the same
  	spot the order turns out to be the order sent. this is also why the msgs might be up side down.
  - sadly there's no way to customize the fzf keybinds without modifying the source so if something doesn't
	work for you feel free to do a global replace of the bind (the keynames are not always what's
	shown in this help so consult the fzf manpage to see what fzf calls them)
  - also unfortunately the program does not check and will not tell you if you've entered something unexpected/wrong
	or do not have all the dependencies installed. so be sure when passing ranges to -d and -r that the lesser number
	is first and pass p|l|m only to options stated to accept them.
```
