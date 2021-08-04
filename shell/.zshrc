################################## OPTIONS ##################################

# Perform cd to a directory if the typed command is invalid, but is a directory.
setopt AUTO_CD
# Make cd push the old directory to the directory stack.
setopt AUTO_PUSHD
# Don't push multiple copies of the same directory to the stack.
setopt PUSHD_IGNORE_DUPS
# Don't print the directory stack after pushd or popd.
setopt PUSHD_SILENT
# Have pushd without arguments act like `pushd ${HOME}`.
setopt PUSHD_TO_HOME

# The file to save the history in.
if (( ! ${+HISTFILE} )) typeset -g HISTFILE=${ZDOTDIR:-${HOME}}/.zhistory
# The maximum number of events stored internally and saved in the history file.
# The former is greater than the latter in case user wants HIST_EXPIRE_DUPS_FIRST.
HISTSIZE=20000
SAVEHIST=10000
# Don't display duplicates when searching the history.
setopt HIST_FIND_NO_DUPS
# Don't enter immediate duplicates into the history.
setopt HIST_IGNORE_DUPS
# Remove commands from the history that begin with a space.
setopt HIST_IGNORE_SPACE
# Don't execute the command directly upon history expansion.
setopt HIST_VERIFY
# Cause all terminals to share the same history 'session'.
setopt SHARE_HISTORY

# Treat `#`, `~`, and `^` as patterns for filename globbing.
setopt EXTENDED_GLOB
# If a pattern for filename generation has no matches, print an error, instead
# of leaving it unchanged in the argument list. This also applies to file
# expansion of an initial '~' or '='.
setopt NOMATCH
# use zsh style word splitting
setopt NOSHWORDSPLIT
# allow expansion in prompts
setopt PROMPT_SUBST
# Allow comments starting with `#` in the interactive shell.
setopt INTERACTIVE_COMMENTS
# Disallow `>` to overwrite existing files. Use `>|` or `>!` instead.
setopt NO_CLOBBER
# no c-s/c-q output freezing
setopt NOFLOWCONTROL
# Try to correct the spelling of commands. Note that, when the HASH_LIST_ALL
# option is not set or when some directories in the path are not readable, this
# may falsely report spelling errors the first time some commands are used.
setopt CORRECT
# whenever a command completion is attempted, make sure the entire command path is hashed first.
setopt HASH_LIST_ALL
# not just at the end
setopt COMPLETE_IN_WORD
# Move cursor to end of word if a full completion is inserted.
setopt ALWAYS_TO_END
# Make globbing case insensitive.
setopt NO_CASE_GLOB
setopt MENU_COMPLETE

# display PID when suspending processes as well
setopt LONGLISTJOBS
# List jobs in verbose format by default.
setopt LONG_LIST_JOBS
# Prevent background jobs being given a lower priority.
setopt NO_BG_NICE
# Prevent status report of jobs on shell exit.
setopt NO_CHECK_JOBS
# Prevent SIGHUP to jobs on shell exit.
setopt NO_HUP
# report the status of backgrounds jobs immediately
setopt NOTIFY

################################## PLUGINS ##################################

source "$HOME/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

zinit light-mode for \
    zinit-zsh/z-a-rust \
    zinit-zsh/z-a-as-monitor \
    zinit-zsh/z-a-patch-dl \
    zinit-zsh/z-a-bin-gem-node

SPACESHIP_PROMPT_SEPARATE_LINE=false
SPACESHIP_VI_MODE_SHOW=false
SPACESHIP_EXIT_CODE_SHOW=true

zinit wait lucid for \
    spaceship-prompt/spaceship-prompt \
    zimfw/input \
    svn is-snippet PZT::modules/git \
    atinit"zicompinit; zicdreplay" \
        zdharma/fast-syntax-highlighting \
    atload"_zsh_autosuggest_start" \
        zsh-users/zsh-autosuggestions \
    blockf atpull'zinit creinstall -q .' \
        zsh-users/zsh-completions \
    atload'bindkey "^[[A" history-substring-search-up; bindkey "^[[B" history-substring-search-down' \
        zsh-users/zsh-history-substring-search \
    atclone"dircolors -b LS_COLORS > c.zsh" atpull'%atclone' pick"c.zsh" nocompile'!' \
        trapd00r/LS_COLORS \

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
