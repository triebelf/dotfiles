[[ "$-" != *i* ]] && return
export PS1='\W> '

set -o vi
export EDITOR=vim

set -o notify
HISTCONTROL=erasedups:ignoredups:ignorespace
HISTSIZE=1000
HISTFILESIZE=2000
shopt -s histappend
shopt -s checkwinsize
shopt -s globstar

alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
