################################## OPTIONS ##################################
# Changing Directories
setopt AUTO_CD
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS

# Completion
setopt ALWAYS_TO_END
setopt AUTO_LIST
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
setopt CORRECT_ALL
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

################################## KEY BINDINGS ##################################
bindkey -v
typeset -g -A key
key[Home]="${terminfo[khome]}"
key[End]="${terminfo[kend]}"
key[Insert]="${terminfo[kich1]}"
key[Backspace]="${terminfo[kbs]}"
key[Delete]="${terminfo[kdch1]}"
key[Up]="${terminfo[kcuu1]}"
key[Down]="${terminfo[kcud1]}"
key[Left]="${terminfo[kcub1]}"
key[Right]="${terminfo[kcuf1]}"
key[PageUp]="${terminfo[kpp]}"
key[PageDown]="${terminfo[knp]}"
key[Shift-Tab]="${terminfo[kcbt]}"
[[ -n "${key[Home]}" ]] && bindkey -- "${key[Home]}" beginning-of-line
[[ -n "${key[End]}" ]] && bindkey -- "${key[End]}" end-of-line
[[ -n "${key[Insert]}" ]] && bindkey -- "${key[Insert]}" overwrite-mode
[[ -n "${key[Backspace]}" ]] && bindkey -- "${key[Backspace]}" backward-delete-char
[[ -n "${key[Delete]}" ]] && bindkey -- "${key[Delete]}" delete-char
[[ -n "${key[Up]}" ]] && bindkey -- "${key[Up]}" history-substring-search-up
[[ -n "${key[Down]}" ]] && bindkey -- "${key[Down]}" history-substring-search-down
[[ -n "${key[Left]}" ]] && bindkey -- "${key[Left]}" backward-char
[[ -n "${key[Right]}" ]] && bindkey -- "${key[Right]}" forward-char
[[ -n "${key[PageUp]}" ]] && bindkey -- "${key[PageUp]}" beginning-of-buffer-or-history
[[ -n "${key[PageDown]}" ]] && bindkey -- "${key[PageDown]}" end-of-buffer-or-history
[[ -n "${key[Shift-Tab]}" ]] && bindkey -- "${key[Shift-Tab]}" reverse-menu-complete

# Finally, make sure the terminal is in application mode, when zle is
# active. Only then are the values from $terminfo valid.
if (( ${+terminfo[smkx]} && ${+terminfo[rmkx]} )); then
	autoload -Uz add-zle-hook-widget
	function zle_application_mode_start { echoti smkx }
	function zle_application_mode_stop { echoti rmkx }
	add-zle-hook-widget -Uz zle-line-init zle_application_mode_start
	add-zle-hook-widget -Uz zle-line-finish zle_application_mode_stop
fi

################################## PLUGINS ##################################
source ~/.zplug/init.zsh

zplug 'zplug/zplug', hook-build:'zplug --self-manage'
zplug "mafredri/zsh-async"
zplug "sindresorhus/pure", use:pure.zsh, as:theme
zplug "modules/git", from:prezto
zplug "nekofar/zsh-git-lfs"
zplug "plugins/gpg-agent", from:oh-my-zsh
zplug "trapd00r/LS_COLORS", hook-build:"dircolors -b LS_COLORS >| c.zsh"
zplug "ael-code/zsh-colored-man-pages"
zplug "zsh-users/zsh-completions"
zplug "zsh-users/zsh-autosuggestions", defer:1
zplug "zsh-users/zsh-syntax-highlighting", defer:2
zplug "zsh-users/zsh-history-substring-search", defer:3

if ! zplug check ; then
	zplug install
fi

zplug load  # --verbose

if command -v kubectl &> /dev/null
then
	source <(kubectl completion zsh)
fi

# ignore case completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' '+r:|?=**'

autoload -U zmv

################################## ALIASES ##################################

alias open="xdg-open"
alias top='htop'
alias _='sudo'
alias ll='ls -lh'					# long format and human-readable sizes
alias l='ll -A'						# long format, all files
alias lm="l | ${PAGER}"		# long format, all files, use pager
alias lr='ll -R'					# long format, recursive
alias lk='ll -Sr'					# long format, largest file size last
alias lt='ll -tr'					# long format, newest modification time last
alias lc='lt -c'					# long format, newest status change (ctime) last
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
alias vi='nvim'
alias vim='nvim'

################################## ENVIRONMENT ##################################
# automatically remove duplicates from these arrays
typeset -U path cdpath fpath manpath
path=("$HOME/.local/bin" $path)
export PATH
export EDITOR="nvim"

export PYTHONPYCACHEPREFIX="$(mktemp -d --suffix=_pycache)"

# klist >/dev/null || kinit
