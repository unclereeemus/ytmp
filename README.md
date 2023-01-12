# this is a fork of the now deleted repository ifeelalright1970/ytmp with some changes noted below.

ADDED:
- one can now add local songs or directories (they don't have to follow any name scheme)
 		with the 'a' option (urls work with the option still too)
- increased posix compliance (dash shell) (so far as the scripts shellcheck and checkbashisms can detect)
- some options have been renamed: dmnz - '-d', ntfy - '-n', L - l (among others)

BUG FIXES:
- resolved the possibility of multiple daemons being spawned unwarranted
- resolved the possibility of downloaded songs playing on changing to next song instead of the proper song
- search select works all the time now for both se and s
- an undocumented bug where improper entries were made to the played_urls file has been fixed
- titles with regex characters are no longer butchered in the queue
- pl/pf options work now
- the eww.yuck file has been modified for new bindings and a new widget for system volume

TO BE FIXED:
- moving songs next/previous to currently playing when using fzf or 'm' sometimes
		moves them one/two up/down instead of directly above or below.
		the workaround is to just use vim.
- sometimes thumbnails don't update

# below is the original readme
# --------------------------------------------------------------------------
# ytmp
a shell script that plays (and downloads) music from youtube with an extensive queue manager using fzf, vim, or cli

a newer demo: https://www.reddit.com/user/Rocketqueen_5555/comments/zq72m2/a_new_ytmp_demo_that_i_didnt_know_where_else_to/

an old demo: https://www.reddit.com/r/unixporn/comments/woasvu/oc_ytmp_youtube_music_playing_shell_script_that/

**LATEST CHANGES:**
option to daemonize or not is now available in conf

**options renamed (from - to):**
kl - kd, upd - dmnz

ct - m

pcw - w

ab - a

c - ps

ee - e (replace ytmp.vim if you were using vim!)

rq - dq

**new options:**

ntfy - get notified when mpv closes (i.e. song finishes)

L - play from play history

'G' option renamed to 'l' for 'm' (previously 'ct') also 'p' option is available now- now things like ytmp m 'p+20' 'p-10' and ytmp m 'l-10' 'l-2' can be done that is to say entries can be moved relative to what's currently playing and the last entry

**other:**

a conf file is now available

notifications are now avialable

new binds for search (c-a-s/e)

a previous bug made thumbnail files save with asterisks, i fixed it. if you want to remove asterisks from any past saved files, run this: `find $thumbnail_dir -regex '.*\\\*\\\*\\\*.*' | while read -r f; do mv -iv $f "$( echo "$f" | sed 's@\\\*\\\*\\\*@@g' )"; done`

**FEATURES:**
  - Keyboard centered
  - Search regular youtube or youtube music (kind of... in a round about way. see `ytmp h` for explanation)
  - Download songs after they have been played a chosen amount of times (and play the download in the future)
  - Add playlists to the queue
  - Switch playlists/queues on the fly!
  - Shuffle queue
  - Select from multiple search results
  - Manage queue from cli, nvim, fzf
  - Keep track of listen history/amount
  - Everything is a plain text file!
  - Integration with eww widgets (through mpvsocket)

**BUGS:**
- moving songs next/previous to currently playing when using fzf sometimes
		moves them one/two up/down instead of directly above or below (also happened when I was using a sed method.) the workaround is to just use vim.
- search select doesn't work sometimes (if it's the 's' option working up then one can use the 'se' option and vice versa)
- sometimes the program won't daemonize and play one song after another ends most in cases where you open vim with `ytmp E` before anything else. could manually be daemonized with `ytmp upd` (probably an easy fix -- see the bottom of the script for how it's decided whether to daemonize a new version)
- if the title contains regex characters like &[] it's like the title will get butchered in the queue file (because sed interprets them as regex)
- sometimes `ytmp n` or the daemon doesn't play next song after one is over and instead all the downloaded files are played (i don't know why)
- sometimes many instances of ytmp are forked
- sometimes thumbnails don't update

**TO BE ADDED:**
- add option to allow local songs/directories that don't have youtube ids in front of their name to be added to the queue
- keybinding to download entry from `ytmp v`
- only update the amount a song has been played after a certain percentage of the song progresses so the counter doesn't accidentally go up and the script doesn't download songs you didn't want to
- show more helpful/pretty cli output and remove unnecessary ones i.e. ls output
- dedicated ui

# DEPS: fzf, yt-dlp, mpv, socat, (n/vim, pipe-viewer(https://github.com/trizen/pipe-viewer/))
# setup
`git clone --depth 1 'https://github.com/ifeelalright1970/ytmp/'`

`cd ytmp`

`chmod +x ytmp mpv_socket_commands mpv_socket_selector run_on_next`

(link/move ytmp to one of your paths like) `[ln/mv] ytmp /home/$USER/.local/bin/`

(if intending to use n/vim) `mv ytmp.vim ~/.config/nvim/`

(and move run_on_next to your preferred location - it is looked for in ~/Music/ytmp/ by default)

the mpv ipc socket is opened at /tmp/mpvsocketytmp

## on first run
the first time you run ytmp there won't be any history to select from when you enter fzf so you can pass your search from the cli like
`ytmp <search>` or `ytmp S <search>` (look at `ytmp h` for the difference) or you can enter fzf and press ctrl-/ to pass your input field
as the search or ctrl-s/ctrl-e to background the search so you can make a new search.

## eww setup
`chmod +x mus`

`eww -c . open/close musicplayer` or `mv {eww.scss,eww.yuck,mus} ~/.config/eww`; `eww open/close musicplayer`

the thumbnail is located at /tmp/muscover.png

the mpv ipc socket is opened at /tmp/mpvsocketytmp

if things don't look right, you can also look through https://github.com/ifeelalright1970/eww-config for my complete config but it's much less cleaner and you will have to sort some things yourself!

# scripts explanations
**mpv_socket_selector** prints a menu of active mpv sockets and puts the selected one in /tmp/active_mpvsocket

**mpv_socket_commands** sends commands to the mpv socket in /tmp/active_mpvsocket or another specfied with st option

**run_on_next** runs on the start of every song which can be used to keep some consistent settings within mpv (volume, loop, seek, etc)

**eww.scss/eww.yuck** contain the eww music widget

**mus** is used by the eww config for various information

**mightfinduseful** script to play music outside of ytmp either with local files, youtube search, or the ytmp queue file. also dynamically names the mpvsocket so you don't overwrite an old one.

**ytmp.vim** a vim config that has useful keybinds (would recommend over using fzf due to speed/reliability)

# tips
- in the demo above some of the cli options have different names now [mf/ml - mfn/mln] or aren't even featured because of my oversight so trust `ytmp h` instead
- convert spotify playlists to something ytmp can use: export the playlist to csv with https://github.com/watsonbox/exportify then run `cut -d'"' --output-delimiter=' ' -f4,8 PLAYLIST_PATH.csv | sed -n 1d | sed -E -e 's/[_[:alnum:]]* ?\(?R?r?emaster[ed]?\)? ?[_[:alnum:]]*//g' -e 's/ ?- ?/ /g' -e 's/  //g' | xargs -d '\n' -I ',,' yt-dlp --print id --print title ytsearch1:",, auto-generated provided to youtube" | paste -s -d ' \n' > file` if the playlist is very large, it can take some time to finish the operation in one go in which case one can divide the searches in chunks and search using this script (and `cat` it all together afterwards of course): https://gist.github.com/ifeelalright1970/3a028340c5d0a59461195a6b6fbfd128
- get the $num songs immediately before and after currently playing: `num=3; line=$( grep -n '\*\*\*$' /home/$USER/Music/ytmp/queue | cut -d':' -f1 ); sed -n "$( echo "${line}-${num}" | bc )","$( echo "${line}+${num}" | bc )"p /home/$USER/Music/ytmp/queue | cut -d' ' -f2-` or send a notification: `num=1; line=$( grep -n '\*\*\*$' /home/$USER/Music/ytmp/queue | cut -d':' -f1 ); notify-send "$( sed -n "$( echo "${line}-${num}" | bc )","$( echo "${line}+${num}" | bc )"p /home/$USER/Music/ytmp/queue | cut -d' ' -f2- )"`
- to play random songs one after another, run `while $( ytmp ntfy ); do grep -c '' "/home/$USER/Music/ytmp/queue" | xargs seq | shuf -n 1 | xargs ytmp e; done`
- to play a random song once, run `grep -c '' "/home/$USER/Music/ytmp/queue" | xargs seq | shuf -n 1 | xargs ytmp e`
- you don't need to use ytmp to make playlists for it! you could do `yt-dlp --print id --print title '<playlist_url>' | paste -s -d ' \n' > file` or to search for playlists from the terminal: `query='SEARCH' && pipe-viewer --no-interactive -sp --custom-playlist-layout='*VIDEOS*VIDS *TITLE* *URL*' "$query" | fzf --bind='alt-a:beginning-of-line,alt-e:end-of-line,ctrl-a:execute(echo {} | awk "{print $NF}" | xargs -0 -I ",," pipe-viewer --custom-layout="*AUTHOR* *TIME* *TITLE*" --no-interactive ",," | fzf)' | awk '{print $NF}' | xargs -0 -I ',,' yt-dlp --print id --print title ',,' | paste -s -d ' \n' > file`
- if you listen to symphonies or other things whose titles start in a simlar fashion you can sort them alphabetically to group them together in chronological order with this command: `sort -dk2 "$queue" -o "$queue"`
- to sort your play history by how many times you've listened to something use `sort -nk2 "/home/$USER/Music/ytmp/played_urls" | less`
- if you wanted to move multiple songs to one position i.e. the end you could use something like `echo '3,6,27,18' | xargs -d ',' -I '{}' ytmp m '{}' 'l'` (replacing the numbers and 'l' with 'p' or the proper numbers if needed of course)
- you can make a scratchpad (i recommend tdrop if your wm doesn't support them) of `ytmp E` which can be your one stop for music management (you can invoke ytmp with keybindings by using the vim config provided)
- each eww button is bound to different ytmp calls depending on what mouse button is clicked; though there are tooltips for some, they can be cryptic so look in eww.yuck to see what they are and what they might be bound to!
- if there are multiple instances of ytmp or mpv you can select which ones to kill with `pgrep -fa ytmp/mpv | fzf -m | cut -d' ' -f1 | xargs -r kill`
- you can reach out to me / open an issue if something's wrong and I will see if I can help

# credit
https://github.com/Gwynsav/messydots -- for eww config
and a few others who i have burrowed eww scripts/config from but can't remember what i stole from where...

# note
I am a novice at this so if someone experienced would remake this program and better it, i would appreciate it :)
