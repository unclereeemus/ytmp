the changes i've made were for my own use as such just about none of them have been noted in the usage but i'll give you a basic rundown below:

this version does not use an ipc socket bc mpv throws errors when trying to open one so the workaround has been to just use mpv interactively

`ytmp v` is now the option with preview window (hidden by default; toggle with %); some fzf bindings for `ytmp v` have been changed. i would recommend just doing a diff to see all the changes.

notifications: *requires tmux* open a tmux session named ytmp and only use ytmp on this window. the notification has a couple of bindings and a meta binding allowing for alternate keys. it essentially displays the mpv status and allows volume control and tmux keypresses to mpv. 

new features:

specify volume with -v like 'ytmp -v 30 -d ...' 'ytmp -v 30 e ...' *AND* /'ytmp v -v 30' (not typo; 'v' requires -v as an arg)

reading from stdin is now also possible; how it works i cannot find a suitable way to explain.

`ytmp v` '|' binding: play selections; '#': tag entry

'a': pass c to use clipboard as arg

*generally i have introduced some new jank that only i might have use for but i really encourage you to diff this version with the linux version (ik it's all spaghetti and hard to demystify) to find some of the unmentioned additions and fzf bindings*

**setup**
- setup termux to use storage `termux-setup-storage`
- run ytmp in tmux (to use notifications) `tmux new -n ytmp 'ytmp v; sh'`
- $prefix is '/data/data/com.termux/files/home/storage/shared/Music/ytmp'
- make ytmp and ytmpnotif executeable and move to $PATH
