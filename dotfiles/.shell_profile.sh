function mkcd() {
    [[ ! -z $1 ]] && mkdir -p "$1" && cd "$1"
}

function cd_into_file() {
    if [[ -z $1 ]]; then
        builtin cd
    elif [[ -e $1 && ! -d $1 ]]; then
        echo -e "\e[33mConverted invalid destination ($(basename $1)) into dirname\e[0m"
        builtin cd $(dirname $1)
    else
        builtin cd $1
    fi
}

function cd_fzf() {
    [[ ! -z $1 ]] && cd_into_file $1
    file=$(command fzf)
    [[ -e $file ]] && cd_into_file $file
}

function _rm() {
    echo -e "\e[33mUse tr instead\e[0m"
}

alias cd="cd_into_file"
alias cdf="cd_fzf"
alias ta="tmux attach -t"
alias vim="neovim"
alias journalctl='journalctl --reverse'
alias bat='batcat --theme=Visual\ Studio\ Dark+'
alias cat='bat'
alias grep='grep --color=auto'
alias trr='trash-restore'
alias rm='_rm'
alias tr="trash-put"
alias lf="lfrun"
alias calc="qalc"
alias glow="glow -p"
alias ls="eza --long --no-time --icons --octal-permissions --group-directories-first --git"
alias tree="eza --tree"

# Git
alias gs='git status'
alias gc='git commit'
alias gch="git checkout"
alias ga='git add'
alias gb="git branch -vv"
alias gl="git log --oneline --graph --all --decorate"
alias lg="lazygit"
