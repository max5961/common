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
export EDITOR="nvim"
export SUDO_EDITOR="nvim"
export TERMINAL="alacritty"
export BROWSER="brave"

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

alias ls="ls --color"
alias vim="nvim"
alias ta="tmux attach -t"
alias journalctl='journalctl --reverse'
alias bat='bat --theme=Visual\ Studio\ Dark+'
alias grep='grep --color=auto'
alias tr='trash-put'
alias rm="trash-put"
alias trr='trash-restore'
alias lf="lfrun"
alias bsynch="browser-sync start --server --file --watch '*'"

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


mkcd() {
    mkdir -p "$1" && cd "$1"
}

# -----------------------------------------------------------------------------
# Shell integrations
eval "$(fzf --zsh)"
