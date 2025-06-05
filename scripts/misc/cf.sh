#!/usr/bin/env bash

# dest=$(realpath $(find -type 'd','f' | fzf))
dest=$(realpath $(find -L -type d,f | fzf))
dir=""

if [[ -d "$dest" ]]; then
    dir="$dest"
else
    dir=$(dirname $dest)
fi

[[ -d "$dir" ]] && cd "$dir" && $SHELL

