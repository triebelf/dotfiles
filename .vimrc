" tell vim where to put swap files
set dir=/tmp

" use system clipboard
set clipboard^=unnamed,unnamedplus

" enable mouse in all modes
set mouse=a

" use 4 spaces for tabs
set tabstop=4 shiftwidth=4 expandtab

set diffopt+=iwhite
set ic
set hlsearch

" all color values are set by the terminal theme (requires vim-dim plugin)
set background=dark
colorscheme dim

" accurate but slow syntax highlighting
autocmd BufEnter * :syntax sync fromstart

" gitgutter plugin configuration
set updatetime=100

" ALE plugin configuration
let g:ale_echo_msg_format='[%linter%] [%severity%] %code% %s'
nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)

" mergetool configuration
let g:mergetool_layout = 'bmr'
" possible values: 'local' (default), 'remote', 'base'
let g:mergetool_prefer_revision = 'local'
