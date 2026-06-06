#!/usr/bin/env bash

[[ -z "$1" ]] && echo "missing argument" && exit 1
[[ "$1" == "--list" ]] && echo -e "[COLORS]" && cat "$HOME/.cache/wal/colors" && exit 0

HEX="$1"
LEFT_HEX="${HEX:0:5}"

function next_hex() {
    local next_right_hex=$(printf "%X\n" "$right_dec")
    printf "${LEFT_HEX}${next_right_hex}"
}

function append_line() {
    result+="gradient_color_$level = '$(next_hex)'\n"
}

function main() {
    local right_hex=${HEX:5}
    local right_dec=255
    local result=""

    for i in {1..8}; do
        level="$i"
        append_line
        ((right_dec-=20))
    done

    printf "$result"
}

main





