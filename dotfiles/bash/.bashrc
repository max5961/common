# default apps
export EDITOR="nvim"
export SUDO_EDITOR="nvim"
export TERMINAL="alacritty"
export BROWSER="brave"

# settings for common commands
alias vim='nvim'
alias vimd='nvim .'
alias ls='ls --color=auto'
alias grep='grep --color=auto'

# custom commands
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# prompt
PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '

# vim editing mode
# commented out because alacritt has a vim mode
# set -o vi
# If not running interactively, don't do anything
# [[ $- != *i* ]] && return

