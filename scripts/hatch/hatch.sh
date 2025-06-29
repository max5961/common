#!/usr/bin/env bash

FOLDER="$HOME/common/scripts/hatch"
EGGS=$(fdfind -d 1 -t d . "$FOLDER" | xargs -I {} basename {})
ARGS="$@"
HERE=false
NEW=false
DEST=

function print_help() {
    echo -e "Usage: hatch [OPTION]... PATTERNS...\n"
    echo OPTIONS:
    echo "$EGGS" | awk '{ printf("  --%s\n", $NF) }'
    echo -e "\nPATTERNS"
    echo "  --here  Create egg in cwd"
    echo "  --new   Replace the destination directory"

    exit 0
}

function set_vars() {
    local egg="$1"
    DEST="$HOME/void/${egg}-test"

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
            echo -e "Directory not empty\nAborting"; exit 1
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
    set_vars "$egg"
    if args_includes "--${egg}"; then
        local template="${FOLDER}/${egg}/template"
        local wiped_dir=false

        mkdir -p "$DEST" && cd "$DEST"
        if "$NEW" || [[ -z "$(ls -A)" ]]; then
            wiped_dir=true
            rm -rf "$DEST"/* "$DEST"/.*
            cp -r "$template"/* . && ls -a "$template"/.* >/dev/null 2>&1 && cp -r "$template"/.* .
        fi

        # Specific configurations/chores that need to be ran depending on setup
        case $egg in
            ts)
                if $wiped_dir; then
                    npm init -y &> /dev/null
                    git init
                    echo "node_modules/" >> "$DEST/.gitignore"
                    echo "*.log" >> "$DEST/.gitignore"
                    npm install
                    npx prettier --write ./*
                    update-package-versions
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
    fi
}

function main() {
    args_includes "--help" && print_help


    local matched_setup_flag=false

    for egg in ${EGGS[@]}; do
        dispatch_egg
        args_includes "--${egg}" && matched_setup_flag=true
    done

    if ! "$matched_setup_flag"; then
        echo "Invalid flags" && print_help
    fi
}

main
