#!/usr/bin/env bash

EGGS=(ts html)
ARGS="$@"
HERE=
DEST=
NEW=

function set_vars() {
    DEST="$1"

    for arg in $ARGS; do
        case "$arg" in
            --new)
                NEW=0
                ;;
            --here)
                DEST="$(pwd)"
                HERE=0
                ;;
        esac
    done

    if [[ "$NEW" && "$HERE" && ! -z "$(ls -A $DEST)" ]]; then
        echo -e "Directory not empty\nAborting"; exit 1
    fi
}

function args_includes() {
    for arg in $ARGS; do
        case "$arg" in
            "$1") return 0 ;;
        esac
    done

    return 1;
}

function dispatch_egg() {
    set_vars "$HOME/void/${egg}-test"
    args_includes "--${egg}" && "${eggs_dir}/${egg}/__hatch-${egg}.sh" "$DEST" "$NEW"
}

function main() {
    local eggs_dir="$HOME/common/scripts/hatch"
    local matched_setup_flag=

    for egg in ${EGGS[@]}; do
        dispatch_egg

        args_includes "--${egg}" && matched_setup_flag=0
    done

    if [[ -z "$matched_setup_flag" ]]; then
        echo "Invalid flags"
    fi
}

main
