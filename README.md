# Collection of my dotfiles

- minimalism, keep the configuration files small
- focus on development using vim
- git configuration
- separate zsh configuration using zimfw framework

## Terminal

Select a terminal that supports copy-paste through ssh sessions, for example
xterm, mintty (Windows) or Alacritty, see [this
page](https://github.com/ojroques/vim-oscyank).

## tmux

- Prefix is Ctrl-A instead of the default Ctrl-B.
- vi key bindings
- force zsh for new panes
- use this command to create/attach to ‘main’ session:

> /usr/bin/tmux new-session -A -s main

## vim

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
