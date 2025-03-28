# -----------------------------------------------------------------------------
# Makes sure prompt is loaded before plugins
# -----------------------------------------------------------------------------
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# -----------------------------------------------------------------------------
# ZINIT PACKAGE MANAGER
# -----------------------------------------------------------------------------
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

# -----------------------------------------------------------------------------
# ENV
# -----------------------------------------------------------------------------
export EDITOR="neovim"
export SUDO_EDITOR="neovim"
export TERMINAL="alacritty"
export BROWSER="brave-browser"
export PATH="$HOME/.local/bin:$PATH:/usr/local/go/bin:$PATH:/$HOME/go/bin"
export PAGER="less -R"

# -----------------------------------------------------------------------------
# PLUGINS
# -----------------------------------------------------------------------------
zinit light Aloxaf/fzf-tab
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit ice depth=1; zinit light romkatv/powerlevel10k
#
# #  Init p10k
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Autosuggest configuration
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=blue"

# Init completion
autoload -Uz compinit
compinit

# -----------------------------------------------------------------------------
# History
# -----------------------------------------------------------------------------
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# add space before command to prevent it from being added to history

# -----------------------------------------------------------------------------
# ZSTYLE
# -----------------------------------------------------------------------------
zstyle ":completion:*" matcher-list "m:{a-z}={A-Za-z}"
# Need zsh-ls-colors for colors to work
# zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ":completion:*" menu no
zstyle ':completion:*' sort true
zstyle ':completion:*:git-checkout:*' sort false

# fzf-tab change default bindings:
# DEFAULT: default_binds=tab:down,btab:up,change:top,ctrl-space:toggle,bspace:backward-delete-char/eof,ctrl-h:backward-delete-char/eof
# CUSTOM:
# alt+j/k = down/up
# tab = down
# alt+space = add option to list of options which will be added to command on tab or enter
# alt+l, enter = exit and add option(s) to command
# esc/backspace = exit (backspace will eventually exit)
zstyle ":fzf-tab:*" fzf-bindings-default "alt-j:down,alt-k:up,alt-l:accept,alt-space:toggle,tab:down,bspace:backward-delete-char/eof"

# Show preview of cd directories in floating window
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'

# -----------------------------------------------------------------------------
# BINDKEY
# -----------------------------------------------------------------------------
# \e, \E, = Escape
# ^[ = Alt key (on some keyboards this is the same as escape)
# ^? = Delete
# ^X, ^ = Control
# ^M = Return
#
# If the VISUAL or EDITOR env contain the string "vi", bindkey will default to
# -v for vi mode.  This sounds great but doesn't work as I would expect.  It won't
# let me backspace in normal mode past text, so I don't understand it well enough to use yet
# bindkey -e overwrites the implied bindkey -v
bindkey -e
bindkey "^[l" autosuggest-accept

# search up/down any list (ctrl-p, ctrl-n also work)
bindkey "^[j" down-line-or-search
bindkey "^[k" up-line-or-search
# bindkey "^[p" history-search-backward
# bindkey "^[n" history-search-forward

# -----------------------------------------------------------------------------
# ALIAS / COMMANDS
# -----------------------------------------------------------------------------
# prefix for aliases to prevent potential naming conflicts
prefix="_"

alias ls="ls --color -1"
alias vim="neovim"
alias journalctl='journalctl --reverse'
alias bat='batcat --theme=Visual\ Studio\ Dark+'
alias grep='grep --color=auto'
alias tr='trash-put'
alias rm="trash-put"
alias trr='trash-restore'
alias lf="lfrun"
alias bsynch="browser-sync start --server --file --watch '*'"
alias calc="qalc"
alias glow="glow -p"
alias cd="file_check_cd"
alias ls="eza --long --no-time --icons --octal-permissions --group-directories-first --git"
alias tree="eza --tree"
alias lock-screen="dm-tool switch-to-greeter"

# tmux
tmux_new_session() {
    if [[ -z "$1" ]]; then
        echo "Provide a session name"; exit 0
    fi
    tmux new-session -t "$1" -c "$2"
}
alias ta="tmux attach -t"
alias tls="tmux list-sessions"
alias tns=tmux_new_session

# git
alias gs='git status'
alias gc='git commit'
alias gch="git checkout"
alias ga='git add'
alias gaa='git add .'
alias gb="git branch -vv"
alias gl="git log --oneline --graph --all --decorate"
alias lg="lazygit"

# zathura
_zathura() {
    if [[ -z "$1" ]]; then
        exit 0;
    fi
    nohup zathura "$1" > /dev/null 2>&1 &
}
alias pdf="_zathura"


_lynx() {
    if [[ -z "$1" ]]; then
        lynx -cfg=~/.config/lynx/lynx.cfg
        exit 0
    fi
    lynx -cfg=~/.config/lynx/lynx.cfg "https://www.duckduckgo.com?q=${*}"
}

alias lynx="_lynx"


mkcd() {
    mkdir -p "$1" && cd "$1"
}

file_check_cd() {
    if [[ -z "$1" ]]; then
        builtin cd
    elif [[ -e "$1" && ! -d "$1" ]]; then
        echo "Destination is not a directory: '$(basename $1)'. Switching to dirname."
        builtin cd $(dirname $1)
        # $EDITOR $1
    else
        builtin cd $1
    fi
}


# -----------------------------------------------------------------------------
# Shell integrations
# not available on this version of fzf
# eval "$(fzf --zsh)"

# >>> juliaup initialize >>>

# !! Contents within this block are managed by juliaup !!

path=('/home/max/.juliaup/bin' $path)
export PATH

# <<< juliaup initialize <<<

# pnpm
export PNPM_HOME="/home/max/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# bun completions
[ -s "/home/max/.bun/_bun" ] && source "/home/max/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
