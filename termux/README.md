the changes i've made were for my own use as such just about none of them have been noted in the usage but i'll give you a basic rundown below:

this version does not use an ipc socket bc mpv throws errors when trying to open one so the workaround has been to just use mpv interactively

`ytmp v` is now the option with preview window (hidden by default; toggle with %); some fzf bindings for `ytmp v` have been changed. i would recommend just doing a diff to see all the changes.

notifications: *requires tmux* open a tmux session named ytmp and only use ytmp on this window. the notification has a couple of bindings and a meta binding allowing for alternate keys. it essentially displays the mpv status and allows volume control and tmux keypresses to mpv. 

new features:

must come before commands:
-v mpv-volume -q|e|v|-d|...
-q t|queue -v|e|v|-d|E|...; t is understood as $tempq

changes to 'v' (only option now; no vv):
%: show prev win
enter: copy entry/selections to the temporary queue and start the daemon
|: copy entry/selections to the temporary queue
pgup: first (no reload)
pgdn: last (no reload)
tab: select+clear-query
!: select
#: -te

other:
-te [-a] entry: tag entry; if -a is passed, append to already present tags otherwise overwrite them
-rq remove the temporary queue
'v' accepts -o to print out selections to stdout
$charlen is 41 for nvim; 45 for the cli. this is to prevent title overflowing. change in source if necessary.

dont put spaces in your queue file name!

if you do `ytmp -q t v` and you select an entry to play it will not play because the $tempq gets overwritten but moving things around will work

'a': pass c to use clipboard as arg

*generally i have introduced some new jank that only i might have use for but i really encourage you to diff this version with the linux version (ik it's all spaghetti and hard to demystify) to find some of the unmentioned additions and fzf bindings*

you can add this to nvim rc for the notifications to work:
`nnoremap <Enter> :execute "terminal ytmp e " . line(".")<CR>i`

**setup**
- setup termux to use storage `termux-setup-storage`
- run ytmp in tmux (to use notifications) `tmux new -n ytmp 'ytmp v; sh'`
- $prefix is '/data/data/com.termux/files/home/storage/shared/Music/ytmp'
- make ytmp and ytmpnotif executeable and move to $PATH
