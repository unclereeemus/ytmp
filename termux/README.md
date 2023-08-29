this version does not use an ipc socket bc mpv throws errors when trying to open one so the workaround has been to just use mpv interactively

notifications: *requires tmux* open a tmux session named ytmp and only use ytmp on this window. the notification has a couple of bindings and a meta binding allowing for alternate keys. it essentially displays the mpv status and allows volume control and tmux keypresses to mpv. 

new features:

must come before commands:
 - -v <mpv-volume> -q|-mpv|e|v|-d|...
 - -q "t"|<file> -v|-mpv|e|v|-d|E|...; specify queue; t is understood as $tempq
 - -mpv <mpvargs> -q|-v|e|v|-d|...; any number of args to start mpv with (quote them as a single arg to ytmp!)

changes to 'v' (only option now; no vv):
 - %: show prev win
 - enter: copy entry/selections to the temporary queue and start the daemon on the queue
 - |: copy entry/selections to the temporary queue
 - [: copy entry to the temporary queue to after currently playing
 - pgup: first (no reload)
 - pgdn: last (no reload)
 - tab: select+clear-query
 - !: select
 - #: -te
 - /: move entry up
 - -: move entry down
 - &: -q t -d

i may have changed/added other bindings but i cant remember which ones. a list of the linux and termux binds can be found in the readme.

other:
 - tag songs with <MPV: {any mpv args}> to have the song start with those args. -v takes preceedence over any --volume in this tag.
 - -te [-a] entry: tag entry; if -a is passed, append to already present tags otherwise overwrite them
 - -rq remove the temporary queue
 - -a read from stdin into \$tempq
 - \- read from stdin into \$tempq (overwrite)
 - 'v' accepts -o to print out selections to stdout
 - \$charlen is 41 for nvim; 45 for the cli. this is to prevent title overflowing. change in source if necessary.
 - suppose you started a queue but forgot to pass '-v', you can just put the volume number in "$cache_dir/mpvvol" and ytmp will use that volume level. dont forget to delete it when it's not necessary anymore or ytmp will go on using it in the future where -v is not passed.
 - -mpv takes preceedence over -v and <MPV:> tag

you can add this to nvim rc for the notifications to work:
`nnoremap <Enter> :execute "terminal ytmp e " . line(".")<CR>i`

**setup**
- setup termux to use storage `termux-setup-storage`
- run ytmp in tmux (to use notifications) `tmux new -n ytmp 'ytmp v; sh'`
- $prefix is '/data/data/com.termux/files/home/storage/shared/Music/ytmp'
- make ytmp and ytmpnotif executeable and move to $PATH

'v' termux v linux binds (termux version runs every ytmp call with '-q $queue' and -v and -mpv args if provided, i removed these in case you wanted to use `uniq`)
```
# TERMUX
$:execute-silent(ytmp -q t m l p)
=: execute(ytmpnotif c)
[: execute(printf '%s+1\n' {+n} | bc | xargs -I ,, sed -n ,,p $queue >> $tempq)+execute-silent(ytmp -q t m l p)+clear-selection+clear-query+pos(1)
]: clear-selection+select+clear-query+pos(1)+next-selected+clear-selection
&: execute(ytmp -d -t; ytmp v)
@: execute(printf '%s+1\n' {+n} | bc | tr '\n' ',' | xargs -I ,, ytmp -v $mpvvol -d ,,; ytmp v)+clear-selection
%: toggle-preview
#: execute-silent(echo {n}+1 | bc | xargs -I ,, ytmp -te ,, &)
|: execute(printf '%s+1\n' {+n} | bc | xargs -I ,, sed -n ,,p $queue >> $tempq)+clear-selection+clear-query+pos(1)
\: clear-selection
!: toggle+down
tab: toggle+clear-query+pos(1)
{: prev-selected
}: next-selected
ctrl-alt-j: pos($playing)
alt-j: pos($mark)
ctrl-alt-x: execute(ytmp x --startwith {q})+reload($cmd)+last
ctrl-alt-s: execute(ytmp s --startwith {q})+reload($cmd)+last
alt-p: execute(ytmp sp --startwith {q})+reload($cmd)+last
alt-z: execute(ytmp z --startwith {q})+reload($cmd)+last
alt-s: execute(ytmp --startwith {q})+reload($cmd)+last
ctrl-alt-f: execute-silent(echo {n}+1 | bc | xargs -I ,, ytmp -af ,,)
ctrl-g: execute-silent(echo {n}+1 | bc | xargs -I ,, ytmp m ,, m)+reload($cmd)
ctrl-l: execute-silent(echo {n}+1 | bc | xargs -I ,, ytmp m l ,,)+reload($cmd)
ctrl-alt-b: execute(ytmp -m)+reload($cmd)
alt-space: execute(echo {n}+1 | bc | xargs -I ,, ytmp m x x ,,)+reload($cmd)
alt-c: execute(echo {n}+1 | bc | xargs -I ,, ytmp m c x x ,,)+reload($cmd)
alt-bspace: execute(echo {n}+1 | bc | xargs -I ,, ytmp m c x ,,)+reload($cmd)
ctrl-space: execute(echo {n}+1 | bc | xargs -I ,, ytmp m x ,,)+reload($cmd)
ctrl-alt-m: execute-silent(echo {n}+1 | bc | xargs -I ,, ytmp m s ,,)+reload($cmd)
alt-up: execute-silent(echo {n}+1 | bc | xargs -I ,, ytmp m ,, 0)+reload($cmd)
alt-down: execute-silent(echo {n}+1 | bc | xargs -I ,, ytmp m ,, l)+reload($cmd)
ctrl-]: execute-silent(ytmp w)
ctrl-r: replace-query
home: clear-query+first
end: clear-query+reload-sync($cmd)+last
alt-r: reload($cmd)
ctrl-alt-d: execute-silent(echo {n}+1 | bc | xargs -I ,, ytmp -dl ,,)
ctrl-z: execute-silent(setsid -f ytmp z {q})
ctrl-s: execute-silent(setsid -f ytmp {q})
ctrl-j: down
ctrl-j:jump,R: execute-silent(echo {n}+1 | bc | xargs -I ,, ytmp m r ,,)+reload($cmd)
/: execute-silent(echo {n}+1 | bc | xargs -I ,, ytmp m ,, -2)+reload($cmd)+up
-: execute-silent(echo {n}+1 | bc | xargs -I ,, ytmp m ,, +1)+reload($cmd)+down
ctrl-k: kill-line
P: execute(ytmp p)+reload($cmd)
N: execute(ytmp n)+reload($cmd)
L: execute-silent(echo {n}+1 | bc | xargs -I ,, ytmp m ,, p)+reload($cmd)
H: execute-silent(echo {n}+1 | bc | xargs -I ,, ytmp m r ,,)+reload($cmd)
ctrl-v: page-down
alt-v: page-up
ctrl-alt-p: half-page-up
ctrl-alt-n: half-page-down
right-click: execute-silent(echo {n}+1 | bc | xargs -I ,, ytmp m ,, p)+reload($cmd)
ctrl-^: execute-silent(ytmp mln)+reload($cmd)
ctrl-\: execute(ytmp E)+reload($cmd)
alt-m: execute(echo {n}+1 | bc | xargs -I ,, ytmp m f ,,)+reload($cmd)
ctrl-o: execute-silent(echo {n}+1 | bc | xargs -I ,, ytmp openInBrowser -e ,,)
pgup: first
pgdn: last

#LINUX
alt-j:pos($(cat $mark_file))
ctrl-alt-x: execute(ytmp x --startwith {q})+reload($cmd)+last
ctrl-alt-s: execute(ytmp s --startwith {q})+reload($cmd)+last
alt-p: execute(ytmp sp --startwith {q})+reload($cmd)+last
alt-z: execute(ytmp z --startwith {q})+reload($cmd)+last
alt-s: execute(ytmp --startwith {q})+reload($cmd)+last
ctrl-alt-f: execute-silent(echo {n}+1 | bc | xargs -I ,, ytmp -af ,,)
ctrl-t: execute-silent(echo {n}+1 | bc | xargs -I ,, ytmp m ,, m)+reload($cmd)
ctrl-l: execute-silent(echo {n}+1 | bc | xargs -I ,, ytmp m l ,,)+reload($cmd)
ctrl-alt-b: execute(ytmp -m)+reload($cmd)
alt-space: execute(echo {n}+1 | bc | xargs -I ,, ytmp m x x ,,)+reload($cmd)
alt-c: execute(echo {n}+1 | bc | xargs -I ,, ytmp m c x x ,,)+reload($cmd)
alt-bspace: execute(echo {n}+1 | bc | xargs -I ,, ytmp m c x ,,)+reload($cmd)
ctrl-space: execute(echo {n}+1 | bc | xargs -I ,, ytmp m x ,,)+reload($cmd)
ctrl-alt-m: execute-silent(echo {n}+1 | bc | xargs -I ,, ytmp m s ,,)+reload($cmd)
alt-up: execute-silent(echo {n}+1 | bc | xargs -I ,, ytmp m ,, 0)+reload($cmd)
alt-down: execute-silent(echo {n}+1 | bc | xargs -I ,, ytmp m ,, l)+reload($cmd)
ctrl-]: execute-silent(ytmp w)
ctrl-r: replace-query
home: reload($cmd)+first
end: reload($cmd)+last
alt-r: reload($cmd)
ctrl-alt-d: execute-silent(echo {n}+1 | bc | xargs -I ,, ytmp -dl ,,)
ctrl-z: execute-silent(setsid -f ytmp z {q})
ctrl-s: execute-silent(setsid -f ytmp {q})
ctrl-j: down
ctrl-j: jump
shift-left: execute-silent(echo {n}+1 | bc | xargs -I ,, ytmp m r ,,)+reload($cmd)
shift-up: execute-silent(echo {n}+1 | bc | xargs -I ,, ytmp m ,, -2)+reload($cmd)+up
shift-down: execute-silent(echo {n}+1 | bc | xargs -I ,, ytmp m ,, +1)+reload($cmd)+down
ctrl-k: kill-line
<: execute-silent(ytmp p)+reload($cmd)
>: execute-silent(ytmp n)+reload($cmd)
return: execute-silent(echo {n}+1 | bc | xargs -I ,, ytmp e ,,)+abort
shift-right: execute-silent(echo {n}+1 | bc | xargs -I ,, ytmp e ,,)+reload($cmd)
right: execute-silent(echo {n}+1 | bc | xargs -I ,, ytmp m ,, p)+reload($cmd)
left: execute-silent(echo {n}+1 | bc | xargs -I ,, ytmp m ,, p-1)+reload($cmd)
ctrl-v: page-down
alt-v: page-up
ctrl-alt-p: half-page-up
ctrl-alt-n: half-page-down
left-click: execute-silent(echo {n}+1 | bc | xargs -I ,, ytmp e ,,)+abort
right-click: execute-silent(echo {n}+1 | bc | xargs -I ,, ytmp m ,, p)+reload($cmd)
ctrl-^: execute-silent(ytmp mln)+reload($cmd)
ctrl-\: execute(ytmp E)+reload($cmd)
alt-m: execute(echo {n}+1 | bc | xargs -I ,, ytmp m f ,,)+reload($cmd)
ctrl-o: execute-silent(echo {n}+1 | bc | xargs -I ,, ytmp openInBrowser -e ,,)
```
