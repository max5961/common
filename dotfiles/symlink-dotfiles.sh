#!/usr/bin/env bash

DOTFILES="$HOME/common/dotfiles"

function symlink() {
    [[ $1 == "symlink-dotfiles.sh" ]] && return

    local path="$HOME/.config/$1"
    [[ -f "$DOTFILES/$1" ]] && path="$HOME/${1}"

    if [[ -d "$path" || -f "$path" || -L "$path" ]]; then
        echo -e "\e[33mNot empty - $(basename $path)\e[0m"
    else
        ln -s "$DOTFILES/$1" "$path"
        [[ "$?" -eq 0 ]] && echo -e "\e[32mSymlinked - $(basename $path)\e[0m"
    fi
}

for file in $DOTFILES/* $DOTFILES/.*; do
    symlink "$(basename $file)"
done
