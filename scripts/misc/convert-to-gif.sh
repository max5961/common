#!/bin/bash

source_file=
if [ -z "${1}" ]; then
    echo "error: missing path of file to convert"
    exit 1
else
    source_file="${1}"
fi

output_file="${source_file%.*}"

ffmpeg -i ${source_file} -vf "fps=10,split[s0][s1];[s0]palettegen[p];[s1][p]paletteuse" -loop -1 ${output_file}.gif
