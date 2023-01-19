# ytmp
a shell script that plays (and downloads) music from youtube with an extensive queue manager using fzf, vim, or cli

an old demo: https://www.reddit.com/r/unixporn/comments/woasvu/oc_ytmp_youtube_music_playing_shell_script_that/

**FEATURES:**
  - Keyboard centered
  - Search regular youtube or youtube music (kind of... in a round about way. see `ytmp h` for explanation)
  - Download songs after they have been played a chosen amount of times (and play the download in the future)
  - Add local files/directories
  - Select from multiple search results
  - Search and add youtube playlists to the queue
  - Manage the queue from cli, nvim, fzf
  - Keep track of listen history/amount
  - Everything is a plain text file
  - Integration with eww widgets (through mpvsocket)

# setup
## DEPS: fzf, yt-dlp, mpv, socat, (n/vim, pipe-viewer(https://github.com/trizen/pipe-viewer/))
`git clone --depth 1 'https://github.com/unclereeemus/ytmp/'`

`cd ytmp`

`chmod +x ytmp mpv_socket_commands mpv_socket_selector run_on_next`

(link/move ytmp to one of your paths like) `[ln/mv] ytmp /home/$USER/.local/bin/`

(if intending to use n/vim) `mv ytmp.vim ~/.config/nvim/`

(and move run_on_next to your preferred location - it is looked for in ~/Music/ytmp/ by default)

the mpv ipc socket is opened at /tmp/mpvsocketytmp

## on first run

On first installing ytmp, there won't be any history to select from when you enter ytmp so either pass arguements from the cli with ytmp [S] <search> or to search what's on the fzf input field press ctrl-x or to background search press ctrl-s / ctrl-z (difference explained in `ytmp h`)

## eww setup
`chmod +x mus`

`eww -c . open/close musicplayer` or `mv {eww.scss,eww.yuck,mus} ~/.config/eww; eww open/close musicplayer`

the thumbnail is located at /tmp/muscover.webp

# scripts explanations
**mpv_socket_selector** prints a menu of active mpv sockets and puts the selected one in /tmp/active_mpvsocket

**mpv_socket_commands** sends commands to the mpv socket in /tmp/active_mpvsocket or another specfied with st option

**run_on_next** runs on the start of every song which can be used to keep some consistent settings within mpv (volume, loop, seek, etc)

**eww.scss/eww.yuck** contain the eww music widget

**mus** is used by the eww config for various information

**mightfinduseful** script to play music outside of ytmp either with local files, youtube search, or the ytmp queue file. also dynamically names the mpvsocket so you don't overwrite an old one.

**ytmp.vim** a vim config that has useful keybinds (would recommend over using fzf due to speed/reliability)

**ytmpsuite** for helpful things like toggling lines in run_on_next, selecting queues, creating playlists, etc.

# tips
- convert spotify playlists to something ytmp can use: export the playlist to csv with https://github.com/watsonbox/exportify then run `cut -d'"' --output-delimiter=' ' -f4,8 PLAYLIST_PATH.csv | sed -n 1d | sed -E -e 's/[_[:alnum:]]* ?\(?R?r?emaster[ed]?\)? ?[_[:alnum:]]*//g' -e 's/ ?- ?/ /g' -e 's/  //g' | xargs -d '\n' -I ',,' yt-dlp --print id --print title ytsearch1:",, auto-generated provided to youtube" | paste -s -d ' \n' > file`

- get the $num songs immediately before and after currently playing: `num=3; line=$( grep -n '\*\*\*$' /home/$USER/Music/ytmp/queue | cut -d':' -f1 ); sed -n "$( echo "${line}-${num}" | bc )","$( echo "${line}+${num}" | bc )"p /home/$USER/Music/ytmp/queue | cut -d' ' -f2-` or send a notification: `num=1; line=$( grep -n '\*\*\*$' /home/$USER/Music/ytmp/queue | cut -d':' -f1 ); notify-send "$( sed -n "$( echo "${line}-${num}" | bc )","$( echo "${line}+${num}" | bc )"p /home/$USER/Music/ytmp/queue | cut -d' ' -f2- )"`

- to play a random song once, run `grep -c '' "/home/$USER/Music/ytmp/queue" | xargs seq | shuf -n 1 | xargs ytmp e`

- you don't need to use ytmp to make playlists for it! you could do `yt-dlp --print id --print title '<playlist_url>' | paste -s -d ' \n' > file` or to search for playlists from the terminal: `query='SEARCH' && pipe-viewer --no-interactive -sp --custom-playlist-layout='*VIDEOS*VIDS *TITLE* *URL*' "$query" | fzf --bind='alt-a:beginning-of-line,alt-e:end-of-line,ctrl-a:execute(echo {} | awk "{print $NF}" | xargs -0 -I ",," pipe-viewer --custom-layout="*AUTHOR* *TIME* *TITLE*" --no-interactive ",," | fzf)' | awk '{print $NF}' | xargs -0 -I ',,' yt-dlp --print id --print title ',,' | paste -s -d ' \n' > file`

- to sort your play history by how many times you've listened to something use `sort -nk2 "/home/$USER/Music/ytmp/played_urls" | less`

- if you wanted to move multiple songs to one position i.e. the end you could use something like `echo '3,6,27,18' | xargs -d ',' -I '{}' ytmp m '{}' 'l'` (replacing the numbers and 'l' with 'p' or the proper positions of course)

- you can make a scratchpad (i recommend tdrop if your wm doesn't support them) of `ytmp E` which can be your one stop for music management (you can invoke ytmp with keybindings by using the vim config provided)

# credit
- this is a fork of the now deleted repo ifeelalright1970/ytmp
- https://github.com/Gwynsav/messydots for eww config
