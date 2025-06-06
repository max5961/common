#!/usr/bin/env bash

SOURCE="$1"
OUTPUT="${SOURCE%.*}"

[[ -z $1 ]] && echo "missing file" && exit 1;
ffmpeg -i "$SOURCE" -vf "fps=30,split[s0][s1];[s0]palettegen[p];[s1][p]paletteuse" -loop -1 ${SOURCE}.gif
