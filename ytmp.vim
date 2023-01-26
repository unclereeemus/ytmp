let mapleader = "\<Space>"
nnoremap <leader>v :source $XDG_CONFIG_HOME/nvim/init.vim<CR>
nnoremap <leader>s :source $XDG_CONFIG_HOME/nvim/ytmp.vim<CR>
nnoremap <leader>e :e $XDG_CONFIG_HOME/nvim/ytmp.vim<CR>
nnoremap <leader>c :e /home/$USER/Music/ytmp/conf<CR>
nnoremap <leader>n :e /home/$USER/Music/ytmp/run_on_next<CR>

" au BufEnter * norm zz
" don't show the exit status of :te commands
:autocmd TermClose * execute 'bdelete! ' . expand('<abuf>')

set ignorecase
set nohlsearch
set number relativenumber

set autoread
set noshowmode
set noruler
set laststatus=0
set noshowcmd

nnoremap <Up> ddkP:w<Enter>
nnoremap <Down> ddp:w<Enter>
nnoremap <Left> dd/\*\*\*$/<Esc>nP:w<Enter>
nnoremap <Right> dd/\*\*\*$/<Esc>np:w<Enter>
nnoremap <S-Up> Gdd/\*\*\*$/<Esc>p:w<Enter>
nnoremap <S-Down> ggdd/\*\*\*$/<Esc>p:w<Enter>
nnoremap <S-Right> ddGp:w<Enter>
nnoremap <S-Left> ddggP:w<Enter>
nnoremap <Enter> :let l = line('.')<Enter>:silent execute '! ytmp e '.shellescape(l)<Enter> |  execute ':redraw!'

nnoremap d dd
nnoremap r :e!<Enter>
nnoremap R /\*\*\*$/<Esc>:s/\*\*\*//g<Enter>:w<Enter>
nnoremap W :w!<Enter>
nnoremap J /\*\*\*$/<Esc>mp

nnoremap <C-s> :te ytmp v<Enter>i
nnoremap <C-t> :te <Enter>i
nnoremap <C-y> :te ytmp<Enter>i
nnoremap <C-w> :te ytmp z<Enter>i
nnoremap <C-v> :te ytmp vv<Enter>i

nnoremap < :silent !ytmp p<Enter>
nnoremap > :silent !ytmp n<Enter>

" replace the volume level in the run_on_next file
nnoremap <leader>v :te echo '' \| dmenu \| xargs -r -I ',,' sed -i 's@vol=.*@vol=,,@' /home/$USER/Music/ytmp/run_on_next<Enter>i
" set volume
nnoremap <leader>l :te echo '' \| dmenu \| xargs -r -I ',,' mpv_socket_commands s volume ',,' st /tmp/mpvsocketytmp <Enter>i
nnoremap <leader>w :te ytmp w<Enter>i
