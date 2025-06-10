#!/bin/bash

DIR="$HOME/Music"
BACKUP="$HOME/void/music-backup"
INPUT_ARTIST="$1"
INPUT_ALBUM="$2"
INPUT_URL="$3"

function check_deps() {
    local ffmpeg="ffmpeg"
    local yt_dlp="yt-dlp"

    which "$ffmpeg" | grep -q "not found" && echo "Missing dep: $ffmpeg" && ((++missing))
    which "$yt_dlp" | grep -q "not found" && echo "Missing dep: $yt_dlp" && ((++missing))
    (( missing > 0 )) && exit 1
}

function draw_line() {
    local cols=$(tput cols)
    local draw_line=""
    for ((i = 1; i <= cols; ++i)); do
        draw_line+="─"
    done
    printf "\e[34m\n%s\n\n\e[0m" "$draw_line"
}

# $1: URL
function yt_dlp_command() {
    [[ -z "$1" ]] && echo "URL not provided to download function" && exit 1
    yt-dlp -x -f bestaudio -o "%(playlist_index)s <<>> %(title)s.%(ext)s" "$1"
}

function download() {
    local artist="$1"
    local album="$2"
    local URL="$3"

    mkdir -p "$DIR/$artist/$album"

    if [[ ! -z "$(ls "$DIR/$artist/$album")" ]]; then
        mkdir -p "$BACKUP/$artist/$album"
        echo "$DIR/$artist/$album not empty.  Moving old contents to $BACKUP/$artist/$album"
        mv "$DIR/$artist/$album/"* "$BACKUP/$artist/$album"
    fi

    cd "$DIR/$artist/$album"

    yt_dlp_command "$URL"
    ARTIST="$artist" ALBUM="$album" node "$HOME/common/scripts/yt-dlp/__setMetadata.js"
    echo "${artist},${album},${URL}" >> "$HOME/common/scripts/yt-dlp/album_dl_log.csv"
}

function get_data() {
    draw_line

    local artist album URL more

    printf "\e[34mArtist: "
    read -r artist

    printf "\e[35mAlbum: "
    read -r album

    printf "\e[36mURL: "
    read -r URL

    printf "\e[96mmore? [type yes]: \e[0m"
    read -r more

    if [[ "$more" == "yes" ]]; then
        get_data
    fi

    draw_line
    download "$artist" "$album" "$URL"
}

function dl_from_csv() {
    local csv="$INPUT_ALBUM"
    [[ ! -f "$csv" ]] && echo "Invalid or missing csv file" && exit 1;

    local i=0
    while IFS=, read -r artist album url; do
        ((++i))
        if [[ ! -z "$artist" && ! -z "$album" && ! -z "$url" ]]; then
            albumdl "$artist" "$album" "$url"
        else
            echo "Skipping draw_line $i due to invalid format."
        fi
    done < "$csv"
}

function main() {
    check_deps
    yt-dlp-precheck

    if [[ "$INPUT_ARTIST" == "--csv" || "$INPUT_ARTIST" == "-c" ]]; then
        dl_from_csv
        exit "$?"
    fi

    if [[ ! -z "$INPUT_ARTIST" && ! -z "$INPUT_ALBUM" && ! -z "$INPUT_URL" ]]; then
        download "$INPUT_ARTIST" "$INPUT_ALBUM" "$INPUT_URL"
        exit "$?"
    fi

    get_data
    exit "$?"
}

main
