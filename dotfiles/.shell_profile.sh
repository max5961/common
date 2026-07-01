mkcd() {
    [[ -n "${1}" ]] && mkdir -p "${1}" && cd "${1}"
}

cd_into_file() {
    if [[ -z "${1}" ]]; then
        builtin cd
    elif [[ -e "${1}" && ! -d "${1}" ]]; then
        echo -e "\e[33mConverted invalid destination ($(basename -- "${1}")) into dirname\e[0m"
        builtin cd "$(dirname -- "${1}")"
    else
        builtin cd "${1}"
    fi
}

get_file_fzf() {
    cd_into_file "${1:-$(pwd)}"
    local file=$(fzf --walker=file,hidden)
    [[ -n "${file}" ]] && realpath -- "${file}"
}

find_files_fzf() {
    local file="$(get_file_fzf "${@}")"
    [[ -e "${file}" || -d "${file}" ]] && cd_into_file "${file}"
}

edit_files_fzf() {
    local file="$(get_file_fzf "${@}")"

    # Using exit 0 would exit the entire shell.  These are not scripts.
    [[ -e "${file}" || -d "${file}" ]] || return 0

    if [[ "${file}" == "$HOME"/* || "${file}" == "$HOME" ]]; then
        cd_into_file "${file}"
        "$EDITOR" "${file}"
    else
        sudoedit "${file}"
    fi
}

trash_restore_fzf() {
    local file="$(trash-list | fzf)"
    [[ -z "${file}" ]] && return 0
    trash-restore "$(echo "${file}" | cut -d ' ' -f3-)"
}

notes() {
    local cwd="$(pwd)"
    cd "$HOME/Documents/notes"
    local chosen="$(fzf --walker=file)"
    [[ -n "${chosen}" ]] && glow -p "${chosen}"
    cd "${cwd}"
}

alias cd='cd_into_file'
alias fzf='fzf --style=full --layout=reverse'
alias ff='find_files_fzf'
alias ffe='edit_files_fzf'
alias ta='tmux attach -t'
alias vim='neovim'
alias journalctl='journalctl --reverse'
alias bat='batcat --theme=Visual\ Studio\ Dark+'
alias cat='bat'
alias grep='grep --color=auto'
alias trr='trash_restore_fzf'
alias rm='trash-put'
alias tr='trash-put'
alias lf='lfrun'
alias calc='qalc'
alias glow='glow -p'
alias ls='eza --long --no-time --icons --octal-permissions --group-directories-first --git'
alias tree='eza --tree'
alias rsync='rsync -av --progress'

# Git
alias gs='git status'
alias gc='git commit'
alias gch='git checkout'
alias ga='git add'
alias gb='git branch -vv'
alias gl='git log --oneline --graph --all --decorate'
alias lg='lazygit'
