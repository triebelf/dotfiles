################################## OPTIONS ##################################
# Changing Directories
setopt AUTO_CD
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS

# Completion
setopt ALWAYS_TO_END
setopt AUTO_MENU
setopt COMPLETE_IN_WORD
setopt HASH_LIST_ALL

# Expansion and Globbing
setopt BAD_PATTERN
setopt NO_CASE_GLOB
setopt EXTENDED_GLOB
setopt NOMATCH

# History
if (( ! ${+HISTFILE} )) typeset -g HISTFILE=${ZDOTDIR:-${HOME}}/.zhistory
HISTSIZE=20000
SAVEHIST=10000
setopt SHARE_HISTORY
setopt HIST_VERIFY
setopt HIST_FIND_NO_DUPS

# Input/Output
setopt NO_CLOBBER
setopt CORRECT
setopt NO_FLOW_CONTROL
setopt INTERACTIVE_COMMENTS

# Job Control
setopt NO_BG_NICE
setopt NO_CHECK_JOBS
setopt NO_HUP
setopt LONG_LIST_JOBS
setopt NOTIFY

# Prompting
setopt PROMPT_SUBST

################################## PLUGINS ##################################

source "$HOME/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

zinit light-mode for \
    zinit-zsh/z-a-rust \
    zinit-zsh/z-a-as-monitor \
    zinit-zsh/z-a-patch-dl \
    zinit-zsh/z-a-bin-gem-node

zinit wait lucid for \
    pick"async.zsh" src"pure.zsh" \
        sindresorhus/pure \
    zimfw/input \
    svn is-snippet \
        PZT::modules/git \
    hkupty/ssh-agent \
    atinit"ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay" \
        zdharma/fast-syntax-highlighting \
    blockf atpull'zinit creinstall -Q .' \
        zsh-users/zsh-completions \
    atload"!_zsh_autosuggest_start" \
        zsh-users/zsh-autosuggestions \
    atload'bindkey "$terminfo[kcuu1]" history-substring-search-up ; bindkey "$terminfo[kcud1]" history-substring-search-down' \
        zsh-users/zsh-history-substring-search \
    atclone"dircolors -b LS_COLORS > c.zsh" atpull'%atclone' pick"c.zsh" nocompile'!' \
        trapd00r/LS_COLORS \
    ael-code/zsh-colored-man-pages \


if command -v kubectl &> /dev/null
then
  source <(kubectl completion zsh)
fi

bindkey -v

# ignore case completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' '+r:|?=**'

autoload -U zmv

################################## ALIASES ##################################

alias open="xdg-open"
alias top='htop'
alias _='sudo'
alias ll='ls -lh'         # long format and human-readable sizes
alias l='ll -A'           # long format, all files
alias lm="l | ${PAGER}"   # long format, all files, use pager
alias lr='ll -R'          # long format, recursive
alias lk='ll -Sr'         # long format, largest file size last
alias lt='ll -tr'         # long format, newest modification time last
alias lc='lt -c'          # long format, newest status change (ctime) last
alias ls='ls --group-directories-first --color=auto'
alias df='df -h'
alias du='du -h'
alias chmod='chmod --preserve-root -v'
alias chown='chown --preserve-root -v'
alias grep='grep --color'
alias sgrep='grep -R -n -H -C 5 --exclude-dir={.git,.svn,CVS} '
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

################################## ENVIRONMENT ##################################
# automatically remove duplicates from these arrays
typeset -U path cdpath fpath manpath
path=("$HOME/.local/bin" $path)
export PATH
export EDITOR="vim"

export PYTHONPYCACHEPREFIX="$(mktemp -d --suffix=_pycache)"

klist >/dev/null || kinit
