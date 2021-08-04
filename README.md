# Felix' Configuration Files

## Features

- stack: alacritty, tmux, zsh, vim, git
- vi key bindings
- true color support
- clipboard integration (works through ssh)
- Python development

Tested on Ubuntu and Manjaro Linux.

### Terminal

Select a terminal that supports copy-paste through ssh sessions, for example
xterm, Windows Terminal or Alacritty, see [this
page](https://github.com/ojroques/vim-oscyank).

Also, the terminal must support [true
color](https://gist.github.com/XVilka/8346728).

Configure this command to create/attach a tmux ‘main’ session:

> /usr/bin/tmux new-session -A -s main

### tmux

- Prefix is Ctrl-A instead of the default Ctrl-B.
- vi key bindings
  - Copy: `Ctrl-A`, then select with `v` and copy with `y`
  - Paste: `Ctrl-P`

### zsh

- fast, asynchronous zsh configuration using [zinit
  framework](https://github.com/zdharma/zinit)
- set sane options
- vi key bindings
- syntax highlighting
- auto suggestions
- completion
- history search with `up` key
- a few aliases

### vim

Configure vim as a complete IDE for Python, C++, shell script development.

- leader key is ‘,’
  - ,p : toggle paste mode
  - ,d : show code documentation
  - ,D : add pydoc string
  - ,k : previous issue
  - ,j : next issue
  - ,g : go to definition
  - ,r : references
  - ,n : rename
  - ,q : quick fix
- plugins (some of those have external dependencies)
  - awesome-vim-colorschemes
  - coc.nvim, which has more nested plugins
    - coc-clangd
    - coc-docker
    - coc-groovy
    - coc-json
    - coc-markdownlint
    - coc-pyright
    - coc-sh
    - coc-tag
    - coc-vimlsp
    - coc-xml
    - coc-yaml
  - ctrlp-py-matcher
  - ctrlp.vim
  - indentpython.vim
  - vim-addon-local-vimrc
  - vim-airline
  - vim-gutentags
  - vim-mergetool
  - vim-oscyank
  - vim-polyglot
  - vim-pydocstring
  - vim-sensible
  - vim-signify
