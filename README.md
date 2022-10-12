# Felix' Configuration Files

This repository contains complete configuration files for Python development on
Linux terminal. Some external dependencies have to be installed manually.

## Features

- terminal, shell, and editor configuration for IDE-like experience
- stack: alacritty, tmux, zsh, neovim, git
- vi key bindings
- true color support
- system clipboard integration
- Python development

Tested on various Linux distributions.

### Terminal

Select a terminal that supports copy-paste through ssh sessions, for example
xterm, kitty, foot, or alacritty, see
[this](https://github.com/ojroques/vim-oscyank).

Also, the terminal must support [true
color](https://gist.github.com/XVilka/8346728).

Configure this command to create/attach a tmux ‘main’ session:

> /usr/bin/tmux new-session -A -s main

### tmux

- Prefix is Ctrl-A instead of the default Ctrl-B.
- vi key bindings
  - Copy: `Ctrl-A` then `Esc` then select with `v` and copy with `y`
  - Paste: `Ctrl-A` then `Ctrl-P`

### zsh

- [zplug](https://github.com/zplug/zplug) zsh plugin manager
- set sane options
- vi key bindings
- syntax highlighting
- auto suggestions
- completion
- history search with `up` key
- a few aliases

### neovim

Configure neovim as a complete IDE for Python and shell script development.

- leader key is comma `,`
- true color support with tokyonight scheme
- treesitter configuration, run `TSInstall` or `TSUpdate`
- automatic tag file generation
- copy to clipboard on yank, even through ssh connection
- autocompletion with many sources
  - language server
  - snippets
  - treesitter
  - buffer
  - path
- language server configuration and hotkeys for code actions
  - Pyright
  - null-ls as wrapper for all kinds of tools
  - jsonls
  - ...
- search with Telescope and hotkeys, for example `,o` search file in git repo
