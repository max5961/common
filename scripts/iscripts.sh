#!/usr/bin/env bash

function should_install() {
    # Helper files start with a double underscore.  Prune helpers and hidden files
    local bn=$(basename "$1")
    if [[ "$bn" == "__"*  || "$bn" == "."* ]]; then
        return 1
    fi

    # Valid extensions
    local ext="${1##*.}"
    case "$ext" in
        sh|js|cpp|c|go|rs|py)
            return 0
            ;;
    esac

    return 1;
}

function should_recurse() {
    local file="$(basename $1)"
    case "$file" in
        node_modules|*template*|src|public|dist|.*)
            return 1;
            ;;
    esac

    return 0;
}

function install() {
    if [[ -d "$1" ]]; then
        for f in "$1"/*; do
            if should_recurse "$f"; then install "$f"; fi;
        done
    elif should_install $1; then
        name=$(basename -- "$1")
        name=${name%.*}
        sudo cp "$1" "/usr/local/bin/$name" && sudo chmod +x "/usr/local/bin/$name"

        [[ "$?" -eq 0 ]] && echo "Installed: $(echo -e "\e[32m$name\e[0m")"
        [[ "$?" -ne 0 ]] && echo "Error installing: $(echo -e "\e[31m$name\e[0m")"
    fi
}

install "$HOME/common/scripts"
