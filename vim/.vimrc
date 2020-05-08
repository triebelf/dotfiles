" tell vim where to put swap files
set directory=$HOME/.vim/tmp//

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

" folding
set foldmethod=indent
set foldnestmax=3
set foldlevel=2

" NERDtree like setup (commands :Ex :Sex :Vex)
let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_browse_split = 4
let g:netrw_altv = 1
let g:netrw_winsize = 20
let g:netrw_list_hide= '.*\.swp$,.*\.pyc'

" try to enable true color support
if exists('+termguicolors')
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
    set termguicolors
endif
if $DARK_MODE == 1 " set by shell depending on sunset/sunrise
    set background=dark
    colorscheme jellybeans
else
    colorscheme PaperColor
endif

" accurate but slow syntax highlighting
autocmd BufEnter * :syntax sync fromstart

" [plugin] vim-signify: default updatetime 4000ms is not good for async update
set updatetime=100

" [plugin] ctrlp
let g:ctrlp_max_files=0

" [plugin] gutentags
let g:gutentags_cache_dir = $HOME .'/.cache/gutentags'
let g:gutentags_generate_on_new = 1
let g:gutentags_generate_on_missing = 1
let g:gutentags_generate_on_write = 1
let g:gutentags_generate_on_empty_buffer = 0
let g:gutentags_ctags_extra_args = [ '--tag-relative=yes', '--fields=+ailmnS' ]

" [plugin] YouCompleteMe
let g:ycm_collect_identifiers_from_tags_files = 1
let g:ycm_autoclose_preview_window_after_completion=1
let g:ycm_global_ycm_extra_conf = $HOME .'/.vim/.ycm_extra_conf.py'
let g:ycm_auto_hover = ''

" comma is the leader key
let mapleader=","
" use Ctrl-O and Ctrl-I to move back and forth
map <leader>i  :YcmCompleter GoToInclude<CR>
map <leader>n  :YcmCompleter GoToDeclaration<CR>
map <leader>f  :YcmCompleter GoToDefinition<CR>
map <leader>g  :YcmCompleter GoTo<CR>
map <leader>s  :YcmCompleter GoToImprecise<CR>
map <leader>r  :YcmCompleter GoToReferences<CR>
map <leader>t  :YcmCompleter GetType<CR>
" map <leader>d  :YcmCompleter GetDoc<CR>
nmap <leader>d <plug>(YCMHover)
map <leader>k  :YcmCompleter RestartServer<CR>

" [plugin] ALE
let g:ale_echo_msg_format='[%linter%] [%severity%] %code% %s'
nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)

let g:ale_python_flake8_executable = 'python3'
let g:ale_python_flake8_options = '-m flake8'

let g:ale_python_pylint_executable = 'pylint3'
let g:ale_python_pylint_options = '--disable=invalid-name,missing-docstring'

let g:ale_python_pyflakes_executable = 'pyflakes3'

" in a new .vimrc in your project directory, add this:
" let g:ale_c_clang_options="-I/path/to/your/project"
" let g:ale_cpp_clang_options="-I/path/to/your/project"
