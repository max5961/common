#!/usr/bin/env bash

NOTES="$HOME/Documents/notes"

exec_fzf() {
    cd "$NOTES"
    chosen=$(fzf --style=full --layout=reverse --walker=file,follow)
    [[ -n "${chosen}" ]] && "${editor}" "${chosen}"
}

main() {
    # default to konsole
    local term="${TERMINAL:-konsole}"
    local editor="$2"

    if [[ ! -z "$1" ]]; then
        exec_fzf
        exit "$?"
    fi

    # script is recursive, $0 is the script path itself
    # $EDITOR was not being recognized with konsole, so force var through as an argument
    "$term" -e "${0}" --run-exec-fzf "$EDITOR" && exit "$?"
}

main "${@}"

