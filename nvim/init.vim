" persist the undo tree for each file
set undofile

" comma is the leader key
let mapleader=","

" toggle paste mode with <leader>-p
set pastetoggle=<leader>p

" use spaces for tabs
set expandtab

" ignore whitespace in diff
set diffopt+=iwhite

" ignore case when searching
set ignorecase

set wildignore+=.*\.swp$
set wildignore+=.*\.pyc$
set wildignore+=__pycache__
set wildignore+=.pytest_cache/
set wildignore+=.*\.egg-info
set wildignore+=\.venv/

" NERDtree like setup (commands :Ex :Sex :Vex)
let g:netrw_liststyle = 3
let g:netrw_browse_split = 4
let g:netrw_altv = 1
let g:netrw_winsize = 15
let g:netrw_banner = 0
let g:netrw_list_hide = &wildignore
let g:netrw_hide = 1
let g:netrw_keepdir=0

" true color support
" let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
" let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
set termguicolors
set background=dark
set cursorline

" [plugin] awesome-vim-colorschemes
colorscheme PaperColor

" [plugin] ctrlp.vim
let g:ctrlp_by_filename = 1
let g:ctrlp_max_files = 0
let g:ctrlp_open_new_file = 'v'
let g:ctrlp_user_command = ['.git/', 'git ls-files -oc --exclude-standard %s']

" [plugin] ctrlp-py-matcher
let g:ctrlp_match_func = { 'match': 'pymatcher#PyMatch' }

" [plugin] vim-gutentags
let g:gutentags_cache_dir = $HOME .'/.cache/gutentags'
let g:gutentags_ctags_extra_args = [ '--tag-relative=yes', '--fields=+ailmnS' ]
" let g:gutentags_trace = 1

" [plugin] vim-oscyank
autocmd TextYankPost * if v:event.operator is 'y' && v:event.regname is '' | OSCYankReg " | endif

" [plugin] lspconfig
lua << EOF
require'lspconfig'.pyright.setup{}
require'lspconfig'.hls.setup{}
EOF
