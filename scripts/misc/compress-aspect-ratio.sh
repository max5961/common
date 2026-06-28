#!/usr/bin/env bash

[[ -z "$1" || -z "$2" ]] && echo "USAGE: command [dir] [px-width]" && exit 1

# Removes trailing '/' and extends path
DIR=$(realpath "$1")
PX_WIDTH="$2"
LG_FILE_ID='ORIGINAL_FILE_SIZE-'

for file in $DIR/*; do
    large_name="${DIR}/${LG_FILE_ID}$(basename "${file}")"

    mv "${file}" "${large_name}"
    ffmpeg -i "${large_name}" -vf "scale=$PX_WIDTH:-2" "${file}"
done

read -rp "Delete original files? [y/n]: " answer

if [[ "$answer" == "y" ]]; then
    echo "Deleting original files"
    rm "${DIR}/${LG_FILE_ID}"*
fi


