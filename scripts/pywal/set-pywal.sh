#!/usr/bin/env bash

FLAG="$1"
MAIN=false
TOP=false
BOTTOM=false

function update_target_mon() {
    local flag="$FLAG"

    case "$FLAG" in
        --main)
            MAIN=true
            ;;
        --top)
            TOP=true
            ;;
        --bottom)
            BOTTOM=true
            ;;
    esac
}

function get_target_mon() {
    local contents=$(cat "$HOME/.config/nitrogen/bg-saved.cfg" | grep 'file' | sed 's/file=//g')

    $TOP && echo "$contents" | sed -n '2p' && return
    $BOTTOM && echo "$contents" | sed -n '3p' && return
    echo "$contents" | sed -n '1p'
}

function update_pywal_cache() {
    local mon=$(get_target_mon)
    wal -n -i "$mon"
}

function update_configs() {
    echo "include $HOME/.cache/wal/colors-kitty.conf" > "$HOME/.config/kitty/theme.conf"
    echo -e "[colors]\ninclude-file = $HOME/.cache/wal/colors-polybar" > "$HOME/.config/polybar/theme.ini"
    "$HOME/.config/polybar/launch.sh" &

    # echo -e "set \$borderColor $borderColor" > $forwardFile
    # echo -e "set \$inactiveBorderColor $inactiveBorderColor" >> $forwardFile
    # echo -e "default_border pixel 3" >> $forwardFile
    # echo -e "client.focused \$borderColor \$borderColor \$borderColor \$borderColor" >> $forwardFile
    # echo -e "client.focused_inactive \$inactiveBorderColor \$inactiveBorderColor \$inactiveBorderColor \$inactiveBorderColor" >> $forwardFile
}

function main() {
    update_target_mon
    update_pywal_cache
    update_configs
}

main




