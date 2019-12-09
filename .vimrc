" tell vim where to put swap files
set dir=/tmp

" use system clipboard
set clipboard^=unnamed,unnamedplus

" enable mouse in all modes
set mouse=a

" use 4 spaces for tabs
set tabstop=4 shiftwidth=4 expandtab

set diffopt+=iwhite
set hlsearch

" all color values are set by the terminal theme (requires vim-dim plugin)
set background=dark
colorscheme dim

" required for airline plugin
let g:airline_powerline_fonts=1

" accurate but slow syntax highlighting
autocmd BufEnter * :syntax sync fromstart

" gitgutter plugin
set updatetime=100
