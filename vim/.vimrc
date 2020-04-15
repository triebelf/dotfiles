" tell vim where to put swap files
set dir=/tmp

" use system clipboard
set clipboard^=unnamed,unnamedplus

" enable mouse in all modes
set mouse=a

" use 4 spaces for tabs
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab

set diffopt+=iwhite
set ic
set hlsearch
set wildignore+=*.pyc

" try to enable true color support
if exists('+termguicolors')
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
    set termguicolors
endif
" set background=dark
" colorscheme jellybeans
colorscheme PaperColor

" accurate but slow syntax highlighting
autocmd BufEnter * :syntax sync fromstart

" comma is the leader key
let mapleader=","

" NERDtree like setup (commands :Ex :Sex :Vex)
let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_browse_split = 4
let g:netrw_altv = 1
let g:netrw_winsize = 20
let g:netrw_list_hide= '.*\.swp$,.*\.pyc'

" [plugin] vim-signify: default updatetime 4000ms is not good for async update
set updatetime=100

" [plugin] ctrlp
let g:ctrlp_max_files=0

" [plugin] YouCompleteMe
let g:ycm_autoclose_preview_window_after_completion=1
map <leader>f  :YcmCompleter GoToDefinitionElseDeclaration<CR>
map <leader>r  :YcmCompleter GoToReferences<CR>
" hint: C-^ go back to last open file
map <leader>g  :YcmCompleter GoTo<CR>
map <leader>d  :YcmCompleter GetDoc<CR>
map <leader>t  :YcmCompleter GetType<CR>

" [plugin] ALE
let g:ale_echo_msg_format='[%linter%] [%severity%] %code% %s'
nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)

let g:ale_python_flake8_executable = 'python3'
let g:ale_python_flake8_options = '-m flake8'

let g:ale_python_pylint_executable = 'pylint3'
let g:ale_python_pylint_options = '--disable=invalid-name,missing-docstring'

let g:ale_python_pyflakes_executable = 'pyflakes3'

" function! AutodetectPythonLinter()
"     " Check shebang and if python3 is found, use a python3 linter.
"     " Otherwise fallback to python2.
"     if getline(1) =~ "^#!.*python3"
"         let g:ycm_python_interpreter_path = '/usr/bin/python3'
"         let g:ycm_python_binary_path = '/usr/bin/python3'
"         let g:ale_python_pylint_executable = 'pylint3'
"     else
"         let g:ycm_python_interpreter_path = '/usr/bin/python'
"         let g:ycm_python_binary_path = '/usr/bin/python'
"         let g:ale_python_pylint_executable = 'pylint'
"     endif
" endfunction
" autocmd BufNewFile,BufRead,BufWrite * call AutodetectPythonLinter()
