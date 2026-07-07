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

fzf_styled_with_preview() {
    fzf "${@}" --style=full --layout=reverse --preview='batcat {} --color=always --style=numbers'
}

get_file_fzf() {
    local input_label="${1}"
    local root_dir="${2:-$(pwd)}"
    if [[ -f "${root_dir}" ]]; then root_dir="$(dirname "${root_dir}")"; fi
    local full_label=" ${input_label} - ${$(realpath "${root_dir}" | sed -e "s|^$HOME|~|")%/}/ "

    cd_into_file "${root_dir}"
    if [ "$?" -eq 0 ]; then
        local file=$(fzf_styled_with_preview --walker=file,hidden --input-label="${full_label}")
        [[ -n "${file}" ]] && realpath -- "${file}"
    fi
}

fzf_find_files() {
    local file="$(get_file_fzf 'Find Files' "${@}")"
    [[ -e "${file}" || -d "${file}" ]] && cd_into_file "${file}"
}

fzf_edit_files() {
    local file="$(get_file_fzf 'Edit Files' "${@}")"

    # Using exit 0 would exit the entire shell.  These are not scripts.
    [[ -e "${file}" || -d "${file}" ]] || return 0

    if [[ "${file}" == "$HOME"/* || "${file}" == "$HOME" ]]; then
        cd_into_file "${file}"
        "$EDITOR" "${file}"
    else
        sudoedit "${file}"
    fi
}

fzf_for_grep() {
    fzf "$@" \
        --style=full \
        --layout=reverse \
        --delimiter ':' \
        --preview "$HOME/common/scripts/misc/__batcat_helper {1} {2}"
}

fzf_grep_files() {
    RG_PREFIX="rg --column --line-number --no-heading --color=always --smart-case"
    IGNORE_GLOBS="--glob '!node_modules/**' --glob '!.git/**' --glob '!dist/**' --glob '!target/**'"
    INITIAL_QUERY=""

    if [[ "$1" == "hidden" ]]; then
        RG_PREFIX="${RG_PREFIX} --hidden --no-ignore-vcs"
    else
        RG_PREFIX="${RG_PREFIX} ${IGNORE_GLOBS}"
    fi

    if [[ -f "${2}" || -d "${2}" ]]; then
        cd_into_file "${2}"
    fi

    eval "$RG_PREFIX '$INITIAL_QUERY'" | \
        fzf_for_grep --bind "change:reload:$RG_PREFIX {q} || true,ctrl-h:" \
        --ansi --disabled --query "$INITIAL_QUERY"
}

trash_restore_fzf() {
    local file="$(trash-list | fzf)"
    [[ -z "${file}" ]] && return 0
    trash-restore "$(echo "${file}" | cut -d ' ' -f3-)"
}

notes() {
    local cwd="$(pwd)"
    cd "$HOME/Documents/notes"
    local chosen="$(fzf --walker=file --input-label=' Notes ')"
    [[ -n "${chosen}" ]] && glow -p "${chosen}"
    cd "${cwd}"
}

alias cd='cd_into_file'
alias fzf='fzf_styled_with_preview'
alias ff='fzf_find_files'
alias ffe='fzf_edit_files'
alias ffg='fzf_grep_files non-hidden'
alias ffgh="fzf_grep_files hidden"
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
