#!/bin/bash

# dependencies
dep_kid3=$(which kid3-cli)
dep_yt_dlp=$(which yt-dlp)

missing=0
[[ $(echo "$dep_kid3" | grep "not found") ]] && echo "Missing dependency kid3-cli" && ((++missing))
[[ $(echo "$dep_yt_dlp" | grep "not found") ]] && echo "Missing dependency yt-dlp" && ((++missing))
(( missing > 0)) && exit 1


yt-dlp-precheck

# Aside from dl_command function, arguments correlate to these
# $1 artist
# $2 album
# $3 url

# Pass in the url as the single argument
function dl_command() {
    local artist="$1"
    if [ -z "$1" ]; then echo "Url not supplied to dl_command function"; exit 1; fi

    yt-dlp -x -f bestaudio -o "%(playlist_index)s <<>> %(title)s.%(ext)s" "$1"
}

# Go to the music directory
function nav_to_dir() {
    local artist="$1"
    local album="$2"

    target_dir="$HOME/Music/$artist/$album"
    if_backup_dir="$HOME/void/backup/$artist/$album"

    mkdir -p "$target_dir" && cd "$target_dir";

    if [[ $(ls "$target_dir") != "" ]]; then
        echo "Directory not empty.  Moving directory contents to $if_backup_dir"

        mkdir -p "$if_backup_dir"
        cd && mv "$target_dir" "$if_backup_dir"
        mkdir -p "$target_dir" && cd "$target_dir"
    fi
}

function dl_album() {
    local artist="$1"
    local album="$2"
    local url="$3"

    # Create and cd into directory
    nav_to_dir "$@"

    # Run yt-dlp command
    dl_command "$url"

    # Set metadata (Opens directory $HOME/Music/$ARTIST/$ALBUM)
    ARTIST="$artist" ALBUM="$album" node ~/common/scripts/yt-dlp/setMetadata.js

    # Append to download log
    echo "$artist,$album,$url" >> "$HOME/common/scripts/yt-dlp/album_dl_log.csv"
}

function dl_from_csv() {
    local artist="$1"
    local album="$2"
    local url="$3"

    csv=
    if [[ -z "$album" ]]; then
        read -rp "Enter .csv file path: " csv
    else
        csv="$album"
    fi

    python3 ~/common/scripts/yt-dlp/albumdl/dl-from-csv.py "${csv}"
}

declare albums=();

function dl_albums_from_arr() {
    local idx=${#albums[@]}

    while ((idx != 0)); do
        local url=${albums[((--idx))]}
        local album=${albums[((--idx))]}
        local artist=${albums[((--idx))]}
        dl_album "$artist" "$album" "$url"
    done
}

# Entry point if insufficient arguments provided
function get_info() {
    read -rp "Artist: " artist
    read -rp "Album: " album
    read -rp "URL: " url
    read -rp "More? [type yes]: " more
    albums+=("$artist" "$album" "$url")

    if [[ "$more" == "yes" ]]; then
        get_info
    else
        dl_albums_from_arr
    fi
}

# Download from csv file
if [[ ! -z "$1" ]] && [[ "$1" == "-c" || "$1" == "--csv" ]]; then
    dl_from_csv "$@"
    exit 0
fi

# Otherwise pass in arguments or use prompt
args=("$@")
args_length=${#args[@]}
if (( args_length < 3 )); then
    get_info
else
    dl_album "$@"
fi


