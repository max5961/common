#!/bin/bash

yt-dlp-precheck

# Aside from dlCommand function, arguments correlate to these
# $1 artist
# $2 album
# $3 url

# Pass in the url as the single argument
function dlCommand() {
    local artist="$1"
    if [ -z "$1" ]; then echo "Url not supplied to dlCommand function"; exit 1; fi

    yt-dlp -x -f bestaudio -o "%(playlist_index)s <<>> %(title)s.%(ext)s" "$1"
    # yt-dlp -x -f bestaudio --extract-audio --audio-format mp3 -o "%(playlist_index)s <<>> %(title)s.%(ext)s" "$1"
}

# Go to the music directory
function navToDir() {
    local artist="$1"
    local album="$2"

    targetDir="$HOME/Music/$artist/$album"
    ifBackupDir="$HOME/void/backup/$artist/$album"

    mkdir -p "$targetDir" && cd "$targetDir";

    if [[ $(ls "$targetDir") != "" ]]; then
        echo "Directory not empty.  Moving directory contents to $ifBackupDir"

        mkdir -p "$ifBackupDir"
        cd && mv "$targetDir" "$ifBackupDir"
        mkdir -p "$targetDir" && cd "$targetDir"
    fi
}

function dlAlbum() {
    local artist="$1"
    local album="$2"
    local url="$3"

    # Create and cd into directory
    navToDir "$@"

    # Run yt-dlp command
    dlCommand "$url"

    # Set metadata (Opens directory $HOME/Music/$ARTIST/$ALBUM)
    ARTIST="$artist" ALBUM="$album" node ~/common/scripts/yt-dlp/albumdl/setMetadata.js

    # Append to download log
    echo "$artist,$album,$url" >> "$HOME/common/scripts/yt-dlp/albumdl/dl-log.csv"
}

function dlFromCsv() {
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

function dlAlbumsFromArr() {
    local idx=${#albums[@]}

    while ((idx != 0)); do
        local url=${albums[((--idx))]}
        local album=${albums[((--idx))]}
        local artist=${albums[((--idx))]}
        dlAlbum "$artist" "$album" "$url"
    done
}

# Entry point if insufficient arguments provided
function getInfo() {
    read -rp "Artist: " artist
    read -rp "Album: " album
    read -rp "URL: " url
    read -rp "More? [type yes]: " more
    albums+=("$artist" "$album" "$url")

    local albumsLength=${#albums[@]}
    if [[ "$more" == "yes" ]]; then
        getInfo
    else
        dlAlbumsFromArr
    fi
}

# Download from csv file
if [[ ! -z "$1" ]] && [[ "$1" == "-c" || "$1" == "--csv" ]]; then
    dlFromCsv "$@"
    exit 0;
fi

# Otherwise pass in arguments or use prompt
args=("$@")
argsLength=${#args[@]}
if (( argsLength < 3 )); then
    getInfo
else
    dlAlbum "$@"
fi


