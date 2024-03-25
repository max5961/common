### PERSONAL CONFIGURATION

# prefix for aliases to prevent potential naming conflicts
prefix="_"

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
alias tr='trash-put'
alias trr='trash-restore'
alias journalctl='journalctl --reverse'
alias bat='bat --theme=Visual\ Studio\ Dark+'
alias ta='tmux attach -t'

# git aliases
alias g='git'
alias gs='git status'
alias ga='git add'
alias gp='git push'
# git commit -m
gc() {
    read "message?Enter commit message: "
    git commit -m "${message}"
}

# fzf utilities
# find files (normal, dotfiles, root files)
alias "$prefix"ff='fzf-open-file'
alias "$prefix"ffd='fzf-open-file --hidden'
alias "$prefix"ffr='fzf-open-file --root'
# find grep (for the root option, as long as the file has a normal name it should always work)
alias "$prefix"fg='fzf-grep-contents-open'
alias "$prefix"fgd='fzf-grep-contents-open --hidden'
alias "$prefix"fgr='fzf-grep-contents-open --root'
# cd into (normal, start search from home, start search in root)
alias "$prefix"cd='source fzf-cd-into'
alias "$prefix"cdh='cd && source fzf-cd-into'
alias "$prefix"cdr='cd / && source fzf-cd-into'

# lfimg (runs lfrun on opening lf)
alias lf='lfrun'

# browser sync
alias bsynch="browser-sync start --server --file --watch '*'"

# CUSTOM COMMANDS
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# oapp - open apps in terminal with nohup
oapp() {
    if [ -z "${1}" ]; then
        nohup
    else
        nohup "${1}" > /dev/null 2>&1 &
    fi
}

# change alacritty theme
set-alacritty-theme() {
    if [ -z "${1}" ]; then
        return 1
    fi

    theme="${1}"
    themesDir="$HOME/.config/alacritty/dist/themes/"
    configFile="$HOME/.config/alacritty/alacritty.toml"

    themeExists=false
    for f in "${themesDir}"*; do
        if [ "${theme}.yml" = "$(basename ${f})" ]; then
            themeExists=true
        fi
    done;

    if [ "$themeExists" = false ]; then
        echo "Alacritty theme does not exist"
        return 1
    fi

    sed -i 's|/.config/alacritty/dist/themes/.*|/.config/alacritty/dist/themes/${theme}.toml]' "${configFile}"
}

# empty contents of current working directory
mt() {
    prompt="empty contents of current directory to trash?: [y/n] "

    # options -p: rm -rf contents of current directory
    if [ "${1}" = "-p" ]; then
        prompt="Permanently remove contents of current directory?: [y/n] "
    fi

    read "answer?$prompt"

    success_message="Successfully emptied contents of current directory"
    if [ "${answer}" = "y" ]; then
        if [ "${1}" = "-p" ]; then
            rm -rf ./*; if [ "${?}" = 0 ]; then echo "${success_message}"; fi
        else
            tr ./*; if [ "${?}" = 0 ]; then echo "${success_message}"; fi
        fi
    fi
}

### CONFIGURATION FROM ZSH FOR HUMANS
# Personal Zsh configuration file. It is strongly recommended to keep all
# shell customization and configuration (including exported environment
# variables such as PATH) in this file or in files sourced from it.
#
# Documentation: https://github.com/romkatv/zsh4humans/blob/v5/README.md.

# Periodic auto-update on Zsh startup: 'ask' or 'no'.
# You can manually run `z4h update` to update everything.
zstyle ':z4h:' auto-update      'no'
# Ask whether to auto-update this often; has no effect if auto-update is 'no'.
zstyle ':z4h:' auto-update-days '28'

# Keyboard type: 'mac' or 'pc'.
zstyle ':z4h:bindkey' keyboard  'pc'

# Start tmux if not already in tmux.
#zstyle ':z4h:' start-tmux command tmux -u new -A -D -t z4h

# Whether to move prompt to the bottom when zsh starts and on Ctrl+L.
zstyle ':z4h:' prompt-at-bottom 'no'

# Mark up shell's output with semantic information.
zstyle ':z4h:' term-shell-integration 'yes'

# Right-arrow key accepts one character ('partial-accept') from
# command autosuggestions or the whole thing ('accept')?
zstyle ':z4h:autosuggestions' forward-char 'accept'
# zstyle ':z4h:autosuggestions' tab 'accept'

# Recursively traverse directories when TAB-completing files.
zstyle ':z4h:fzf-complete' recurse-dirs 'yes'

# Enable direnv to automatically source .envrc files.
zstyle ':z4h:direnv'         enable 'no'
# Show "loading" and "unloading" notifications from direnv.
zstyle ':z4h:direnv:success' notify 'yes'

# Enable ('yes') or disable ('no') automatic teleportation of z4h over
# SSH when connecting to these hosts.
zstyle ':z4h:ssh:example-hostname1'   enable 'yes'
zstyle ':z4h:ssh:*.example-hostname2' enable 'no'
# The default value if none of the overrides above match the hostname.
zstyle ':z4h:ssh:*'                   enable 'no'

# Send these files over to the remote host when connecting over SSH to the
# enabled hosts.
zstyle ':z4h:ssh:*' send-extra-files '~/.nanorc' '~/.env.zsh'

### this should make the completion drop down sort in alphabetical order..
### if not sorted in alphabetical order, backspace until the prompt is empty
zstyle ':completion:*' sort true

#zstyle ':completion:*complete:-comamand:*:*' group-order \
#    builtins functions commands

# Clone additional Git repositories from GitHub.
#
# This doesn't do anything apart from cloning the repository and keeping it
# up-to-date. Cloned files can be used after `z4h init`. This is just an
# example. If you don't plan to use Oh My Zsh, delete this line.
#z4h install ohmyzsh/ohmyzsh || return

# Install or update core components (fzf, zsh-autosuggestions, etc.) and
# initialize Zsh. After this point console I/O is unavailable until Zsh
# is fully initialized. Everything that requires user interaction or can
# perform network I/O must be done above. Everything else is best done below.
z4h init || return

# Extend PATH.
path=(~/bin $path)

# Export environment variables.
export GPG_TTY=$TTY

# Source additional local files if they exist.
z4h source ~/.env.zsh

# Use additional Git repositories pulled in with `z4h install`.
#
# This is just an example that you should delete. It does nothing useful.
#z4h source ohmyzsh/ohmyzsh/lib/diagnostics.zsh  # source an individual file
#z4h load   ohmyzsh/ohmyzsh/plugins/emoji-clock  # load a plugin

# Define key bindings.
z4h bindkey z4h-backward-kill-word  Ctrl+Backspace     Ctrl+H
z4h bindkey z4h-backward-kill-zword Ctrl+Alt+Backspace

z4h bindkey undo Ctrl+/ Shift+Tab  # undo the last command line change
z4h bindkey redo Alt+/             # redo the last undone command line change

z4h bindkey z4h-cd-back    Alt+Left   # cd into the previous directory
z4h bindkey z4h-cd-forward Alt+Right  # cd into the next directory
z4h bindkey z4h-cd-up      Alt+Up     # cd into the parent directory
z4h bindkey z4h-cd-down    Alt+Down   # cd into a child directory

# Autoload functions.
autoload -Uz zmv

# Define functions and completions.
function md() { [[ $# == 1 ]] && mkdir -p -- "$1" && cd -- "$1" }
compdef _directories md

# Define named directories: ~w <=> Windows home directory on WSL.
[[ -z $z4h_win_home ]] || hash -d w=$z4h_win_home

# Define aliases.
alias tree='tree -a -I .git'

# Add flags to existing aliases.
# alias ls="${aliases[ls]:-ls} -A"

# Set shell options: http://zsh.sourceforge.net/Doc/Release/Options.html.
setopt glob_dots     # no special treatment for file names with a leading dot
setopt no_auto_menu  # require an extra TAB press to open the completion menu
