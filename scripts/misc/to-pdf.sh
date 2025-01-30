#!/usr/bin/env bash

if [[ -z "$1" ]]; then
    echo "Provide an argument"
    exit 1
fi

file="$1"
strippedFileName=$(basename -- "$file" ".${file##*.}")

pandoc "$file" -o "$strippedFileName.pdf" --pdf-engine wkhtmltopdf
