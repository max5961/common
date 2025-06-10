source "$HOME/.shell_profile.sh"

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
# -v for vi mode.
bindkey "^H" backward-delete-char
bindkey "^?" backward-delete-char
# bindkey -e
# bindkey "^[l" autosuggest-accept
# bindkey "^[j" down-line-or-search
# bindkey "^[k" up-line-or-search
# bindkey "^[w" forward-word
# bindkey "^[b" backward-word
# bindkey "^[h" backward-char
# bindkey "^[l" forward-char

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
