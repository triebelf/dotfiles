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

" all color values are set by the terminal theme (requires vim-dim plugin)
set background=light
colorscheme dim

" accurate but slow syntax highlighting
autocmd BufEnter * :syntax sync fromstart

" comma is the leader key
let mapleader=","

" [plugin] YouCompleteMe
let g:ycm_autoclose_preview_window_after_completion=1
map <leader>f  :YcmCompleter GoToDefinitionElseDeclaration<CR>
map <leader>r  :YcmCompleter GoToReferences<CR>
" hint: C-^ go back to last open file
map <leader>g  :YcmCompleter GoTo<CR>
map <leader>d  :YcmCompleter GetDoc<CR>
map <leader>t  :YcmCompleter GetType<CR>

" [plugin] ALE
function! AutodetectPythonLinter()
    " Check shebang and if python3 is found, use a python3 linter.
    " Otherwise fallback to python2.
    if getline(1) =~ "^#!.*python3"
        let g:ycm_python_interpreter_path = '/usr/bin/python3'
        let g:ycm_python_binary_path = '/usr/bin/python3'
        let g:ale_python_pylint_executable = 'pylint3'
    else
        let g:ycm_python_interpreter_path = '/usr/bin/python'
        let g:ycm_python_binary_path = '/usr/bin/python'
        let g:ale_python_pylint_executable = 'pylint'
    endif
endfunction
autocmd BufNewFile,BufRead,BufWrite * call AutodetectPythonLinter()
let g:ale_python_pylint_options = '--disable=invalid-name,missing-docstring'
let g:ale_echo_msg_format='[%linter%] [%severity%] %code% %s'
nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)
