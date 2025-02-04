#!/usr/bin/env bash

if [[ -z "$1" ]]; then
    echo "Provide an argument"
    exit 1
fi

# Dir variable ensures that the output pdf is on the same level as the input file
file="$1"
dir=$(realpath $(dirname $file))
strippedFileName=$(basename -- "$file" ".${file##*.}")

pandoc "$file" -o "$dir/$strippedFileName.pdf" --pdf-engine wkhtmltopdf
