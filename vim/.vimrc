" tell vim where to put swap files
set directory=$HOME/.vim/tmp//

" use system clipboard
set clipboard^=unnamed,unnamedplus

" comma is the leader key
let mapleader=","

" enable mouse in all modes
set mouse=""

" use 4 spaces for tabs
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab

set diffopt+=iwhite
set ic
set hlsearch
set wildignore+=*.pyc

" always show signcolumns
set signcolumn=yes

" faster updates
set updatetime=100

" folding
" set foldmethod=indent
" set foldnestmax=3
" set foldlevel=2

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

" [plugin] tagbar
nnoremap <silent> <F9> :TagbarOpenAutoClose<CR>

" [plugin] ctrlp
let g:ctrlp_by_filename = 1
let g:ctrlp_max_files = 0
let g:ctrlp_open_new_file = 'v'
let g:ctrlp_user_command = ['.git/', 'git ls-files -oc --exclude-standard %s']
let g:ctrlp_match_func = { 'match': 'pymatcher#PyMatch' }
let g:ctrlp_lazy_update = 100

" [plugin] gutentags
let g:gutentags_cache_dir = $HOME .'/.cache/gutentags'
let g:gutentags_ctags_extra_args = [ '--tag-relative=yes', '--fields=+ailmnS' ]

" [plugin] coc.nvim
function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~ '\s'
endfunction

inoremap <silent><expr> <TAB>
    \ pumvisible() ? "\<C-n>" :
    \ <SID>check_back_space() ? "\<TAB>" :
    \ coc#refresh()

" use <c-space> for trigger completion
inoremap <silent><expr> <NUL> coc#refresh()

nmap <silent> <leader>g <Plug>(coc-definition)
nmap <silent> <leader>t <Plug>(coc-type-definition)
nmap <silent> <leader>i <Plug>(coc-implementation)
nmap <silent> <leader>r <Plug>(coc-references)
nmap <leader>n <Plug>(coc-rename)
xmap <leader>f <Plug>(coc-format-selected)
nmap <leader>f <Plug>(coc-format)
xmap <leader>a <Plug>(coc-codeaction-selected)
nmap <leader>a <Plug>(coc-codeaction-selected)
nmap <leader>c <Plug>(coc-codeaction)
nmap <leader>q <Plug>(coc-fix-current)
nmap <silent> <leader>k <Plug>(coc-diagnostic-prev)
nmap <silent> <leader>j <Plug>(coc-diagnostic-next)
nnoremap <silent> <leader>d :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" [plugin] ALE
let g:ale_echo_msg_format='[%linter%] [%severity%] %code% %s'
nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)

function! AutodetectPythonLinter()
    " Check shebang and if python3 is found, use a python3 linter.
    " Otherwise fallback to python2.
    if getline(1) =~ "^#!.*python3"
        let g:ale_python_flake8_executable = 'python3'
        let g:ale_python_pylint_executable = 'pylint3'
        let g:ale_python_pyflakes_executable = 'pyflakes3'
    else
        let g:ale_python_flake8_executable = 'python'
        let g:ale_python_pylint_executable = 'pylint'
        let g:ale_python_pyflakes_executable = 'pyflakes'
    endif
    let g:ale_python_flake8_options = '-m flake8'
    let g:ale_python_pylint_options = '--disable=invalid-name,missing-docstring'
endfunction
autocmd BufNewFile,BufRead,BufWrite * call AutodetectPythonLinter()

" [plugin] vim-addon-local-vimrc
" in a new .vimrc in your project directory, add this:
" let g:ale_c_clang_options="-I/path/to/your/project"
" let g:ale_cpp_clang_options="-I/path/to/your/project"
