################################## OPTIONS ##################################
# Changing Directories
setopt AUTO_CD
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS

# Input/Output
setopt NO_CLOBBER
setopt CORRECT_ALL
setopt INTERACTIVE_COMMENTS

################################## PLUGINS ##################################
[[ ! -d "$HOME/.antidote" ]] && git clone --depth=1 https://github.com/mattmc3/antidote.git ${ZDOTDIR:-~}/.antidote
source ${ZDOTDIR:-~}/.antidote/antidote.zsh
antidote load

# vi mode and additional key bindings
bindkey -v
[[ -n "${key_info[Up]}" ]] && bindkey -- "${key_info[Up]}" history-substring-search-up
[[ -n "${key_info[Down]}" ]] && bindkey -- "${key_info[Down]}" history-substring-search-down

prompt pure
zstyle :prompt:pure:git:stash show yes
export PURE_PROMPT_SYMBOL="»"
export PURE_PROMPT_VICMD_SYMBOL="«"
export VIRTUAL_ENV_DISABLE_PROMPT=1
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=250"
compstyle 'prezto'
autoload -U zmv

################################## ALIASES ##################################
alias open="xdg-open"
alias top='htop'
alias _='doas'
alias ll='ls -lh'
alias l='ll -A'
alias ls='ls --group-directories-first --color=auto'
alias df='df -h'
alias du='du -h'
alias chmod='chmod --preserve-root -v'
alias chown='chown --preserve-root -v'
alias grep='grep --color'
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias vi='nvim'
alias vim='nvim'
alias http_share='python3 -m http.server 9999'

################################## ENVIRONMENT ##################################
# automatically remove duplicates from these arrays
typeset -gU path cdpath fpath manpath
path=("$HOME/.local/bin" "$HOME/.cargo/bin" $path)
export PATH
export PAGER="${PAGER:-less}"
export EDITOR=nvim

export ZSTD_CLEVEL="7"
export ZSTD_NBTHREADS="0"
