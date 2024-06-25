# DEFAULT APPS
export EDITOR="neovim"
export SUDO_EDITOR="neovim"
export TERMINAL="alacritty"
export BROWSER="brave-browser"
export PATH="$HOME/.local/bin:$PATH:/usr/local/go/bin:$PATH:/$HOME/go/bin"

# SETTINGS FOR COMMON COMMANDS
alias vim='neovim'
alias vimd='neovim .'
alias ls='ls --color=auto'
alias grep='grep --color=auto'

# CUSTOM COMMANDS
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# empty contents of current working directory
mt() {
    # options -f: force remove (rm -rf)
    force=""
    if [ "${1}" = "-f" ]; then
        force="force "
    fi

    read -rp "${force}empty contents of current directory?: [y/n] " answer

    if [ "${answer}" = "y" ]; then
        if [ "${1}" = "-f" ]; then
            rm -rf ./*
        else
            rm -r ./*
        fi
    fi
}

# PROMPT
PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '

# vim editing mode
# commented out because alacritt has a vim mode
# set -o vi
# If not running interactively, don't do anything
# [[ $- != *i* ]] && return

# >>> juliaup initialize >>>

# !! Contents within this block are managed by juliaup !!

case ":$PATH:" in
    *:/home/max/.juliaup/bin:*)
        ;;

    *)
        export PATH=/home/max/.juliaup/bin${PATH:+:${PATH}}
        ;;
esac

# <<< juliaup initialize <<<
