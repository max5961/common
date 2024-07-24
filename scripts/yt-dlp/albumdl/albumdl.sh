#!/bin/bash

yt-dlp-precheck

# Aside from dlCommand function, arguments correlate to these
# $1 artist
# $2 album
# $3 url

# Pass in the url as the single argument
function dlCommand() {
    if [ -z "$1" ]; then echo "Url not supplied to dlCommand function"; exit 1; fi

    yt-dlp -x -f bestaudio -o "%(playlist_index)s <<>> %(title)s.%(ext)s" "$1"
    # yt-dlp -x -f bestaudio --extract-audio --audio-format mp3 -o "%(playlist_index)s <<>> %(title)s.%(ext)s" "$1"
}

# Go to the music directory
function navToDir() {
    targetDir="$HOME/Music/$1/$2"
    ifBackupDir="$HOME/void/backup/$1/$2"

    mkdir -p "$targetDir" && cd "$targetDir";

    if [[ $(ls "$targetDir") != "" ]]; then
        echo "Directory not empty.  Moving directory contents to $ifBackupDir"

        mkdir -p "$ifBackupDir"
        cd && mv "$targetDir" "$ifBackupDir"
        mkdir -p "$targetDir" && cd "$targetDir"
    fi
}

function dlAlbum() {
    # Create and cd into directory
    navToDir "$@"

    # Run yt-dlp command ($3 is the url)
    dlCommand "$3"

    # Set metadata (Opens directory $HOME/Music/$ARTIST/$ALBUM)
    ARTIST="$1" ALBUM="$2" node ~/common/scripts/yt-dlp/albumdl/setMetadata.js

    # Append to download log
    echo "$1,$2,$3" >> "$HOME/common/scripts/yt-dlp/albumdl/dl-log.csv"
}

function dlFromCsv() {
    csv=
    if [[ -z "$2" ]]; then
        read -rp "Enter .csv file path: " csv
    else
        csv="$2"
    fi

    python3 ~/common/scripts/yt-dlp/albumdl/dl-from-csv.py "${csv}"
}

# Entry point if insufficient arguments provided
function getInfo() {
    read -rp "Artist: " artist
    read -rp "Album: " album
    read -rp "URL: " url

    dlAlbum "$artist" "$album" "$url"
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


