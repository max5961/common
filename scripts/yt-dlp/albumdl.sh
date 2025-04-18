#!/bin/bash

# dependencies
dep_kid3=$(which kid3-cli)
dep_yt_dlp=$(which yt-dlp)

missing=0
[[ $(echo "$dep_kid3" | grep "not found") ]] && echo "Missing dependency kid3-cli" && ((++missing))
[[ $(echo "$dep_yt_dlp" | grep "not found") ]] && echo "Missing dependency yt-dlp" && ((++missing))
(( missing > 0)) && exit 1


yt-dlp-precheck

DIR="$HOME/Music"
BACKUP="$HOME/void/music-backup"
INPUT_ARTIST="$1"
INPUT_ALBUM="$2"
INPUT_URL="$3"
DATA=()

# $1: URL
function yt_dlp_command() {
    [[ -z "$1" ]] && echo "URL not provided to download function" && exit 1
    yt-dlp -x -f bestaudio -o "%(playlist_index)s <<>> %(title)s.%(ext)s" "$1"
}

function download() {
    i=${#DATA[@]}
    while (( i >= 3 )); do
        URL=${DATA[((--i))]}
        album=${DATA[((--i))]}
        artist=${DATA[((--i))]}

        mkdir -p "$DIR/$artist/$album"

        if [[ ! -z "$(ls "$DIR/$artist/$album")" ]]; then
            mkdir -p "$BACKUP/$artist/$album"
            echo "$DIR/$artist/$album not empty.  Moving old contents to $BACKUP/$artist/$album"
            mv "$DIR/$artist/$album/" . "$BACKUP/$artist/$album"
        fi

        cd "$DIR/$artist/$album"

        yt_dlp_command "$URL"
        ARTIST="$artist" ALBUM="$album" node "$HOME/common/scripts/yt-dlp/setMetadata.js"
    done
}

function get_data() {
    printf "\e[34mArtist: "
    read -r artist

    printf "\e[35mAlbum: "
    read -r album

    printf "\e[36mURL: "
    read -r URL

    printf "\e[96mmore? [type yes]: \e[0m"
    read -r more

    DATA+=("$artist" "$album" "$URL")

    if [[ "$more" == "yes" ]]; then
        get_data
    else
        download
    fi
}

function dl_from_csv() {
    csv_file="$INPUT_ALBUM"
    [[ ! -f "$csv_file" ]] && echo "Invalid or missing csv file argument" && exit 1

    node "$HOME/common/scripts/yt-dlp/dlFromCsv.js" "$csv_file"
}

function main() {
    if [[ "$INPUT_ARTIST" == "--csv" || "$INPUT_ARTIST" == "-c" ]]; then
        dl_from_csv
        exit "$?"
    fi

    if [[ ! -z "$INPUT_ARTIST" && ! -z "$INPUT_ALBUM" && ! -z "$INPUT_URL" ]]; then
        DATA+=("$INPUT_ARTIST" "$INPUT_ALBUM" "$INPUT_URL")
        download
        exit "$?"
    fi

    get_data
    exit "$?"
}

main

