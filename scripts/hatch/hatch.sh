#!/usr/bin/env bash

SOURCE="$HOME/common/scripts/hatch"
DEST_BASE="$HOME/void"
DEST=
EGGS=$(fdfind -d 1 -t d . "$SOURCE" | xargs -I {} basename {})
ARGS="$@"
HERE=false
NEW=false

function print_help() {
    echo -e "Usage: hatch [OPTION]... PATTERNS...\n"
    echo OPTIONS:
    echo "$EGGS" | awk '{ printf("  --%s\n", $NF) }'
    echo -e "\nPATTERNS"
    echo "  --here  Create egg in cwd"
    echo "  --new   Replace the destination directory"

    exit 0
}

function set_globals() {
    for arg in $ARGS; do
        case "$arg" in
            --new)
                NEW=true
                ;;
            --here)
                DEST="$(pwd)"
                HERE=true
                ;;
        esac
    done

    if "$NEW" && "$HERE"; then
        if [[ -d "$DEST" && ! -z "$(ls -A $DEST)" ]]; then
            echo -e "Directory not empty\nAborting" && exit 1
        fi
    fi
}

function args_includes() {
    for arg in $ARGS; do
        [[ "$arg" == "$1" ]] && return 0
    done

    return 1;
}

function dispatch_egg() {
    "$HERE" || DEST="$DEST_BASE/${egg}-test"

    ! args_includes "--${egg}" && return 1

    local template="${SOURCE}/${egg}/template"
    local dir_is_empty=false

    mkdir -p "$DEST" && cd "$DEST"
    if "$NEW" || [[ -z "$(ls -A)" ]]; then
        dir_is_empty=true
        rm -rf "$DEST"/* "$DEST"/.*
        cp -r "$template"/* . && cp -r "$template"/.* .
    fi

    case $egg in
        ts)
            if $dir_is_empty; then
                git init
                npm install
                npx prettier --write ./*
                update-package-versions
                echo -e "node_modules/\n*.log" >> "$DEST/.gitignore"
            fi
            $EDITOR src/index.ts && exit 0
            ;;
        cpp)
            $EDITOR src/main.cpp && exit 0
            ;;
        sh)
            chmod +x script.sh
            $EDITOR script.sh && exit 0
            ;;
    esac

    return 0
}

function main() {
    set_globals && args_includes "--help" && print_help && return 0

    for egg in ${EGGS[@]}; do
        dispatch_egg && return 0
    done

    echo "Invalid flags" && print_help && return 1
}

main
