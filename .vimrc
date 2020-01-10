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
" TODO set this depending on terminal color scheme
" set background=dark
colorscheme dim

" accurate but slow syntax highlighting
autocmd BufEnter * :syntax sync fromstart

" gitgutter plugin configuration
set updatetime=100

" ALE plugin configuration
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

" mergetool configuration
let g:mergetool_layout = 'bmr'
" possible values: 'local' (default), 'remote', 'base'
let g:mergetool_prefer_revision = 'local'
