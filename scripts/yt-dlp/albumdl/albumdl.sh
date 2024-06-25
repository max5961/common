#!/bin/bash

function navigate_to_dir() {
    dir="$1"

    if [ ! -d "${dir}" ]; then mkdir "${dir}"; fi; cd "${dir}";
}

function dl_single_album() {
    artist=
    album=
    URL=

    if [ -z "${1}" ]; then
        read -rp "Artist: " artist
        read -rp "Album: " album
        read -rp "URL: " URL
    else
        artist="${1}"
        album="${2}"
        URL="${3}"
    fi

    cd ~/Music
    navigate_to_dir "${artist}"
    navigate_to_dir "${album}"

    # download the tracks
    yt-dlp -x -f bestaudio -o "%(playlist_index)s <<>> %(title)s.%(ext)s" "${URL}"

    # set the metadata of each song
    python3 ~/common/scripts/yt-dlp/albumdl/set-metadata.py "${artist}" "${album}"

    # add album, artist, URL to a download log at: ~/common/scripts/python/albumdl/dl-log.csv
    python3 ~/common/scripts/yt-dlp/albumdl/add-to-csv.py "${artist}" "${album}" "${URL}"
}

function dl_from_csv() {
    CSV=

    if [ -z "${1}" ]; then
        read -rp "Enter .csv file path: " CSV
    else
        CSV="${1}"
    fi

    # dl-from-csv.py runs a subprocess that runs single_album_dl
    # with values from the csv passed as args
    # iterating over the csv file in python due to better handling
    # of csv files
    python3 ~/common/scripts/yt-dlp/albumdl/dl-from-csv.py "${CSV}"
}

function check_args() {
    # ***download multiple albums from a csv file
    if [ "${1}" = "--csv" ] || [ "${1}" = "-c" ]; then
        if [ -z "${2}" ]; then
            dl_from_csv
        else
            dl_from_csv "${2}"
        fi

        # ***download single album
        # args should be passed in the format: artist, album, URL
        # if no args are passed, the user will be prompted
    elif [ -z "${1}" ]; then
        dl_single_album

        # args are passed automatically when downloading from a line in a csv
    else
        dl_single_album "${1}" "${2}" "${3}"
    fi
}

# echo "Running yt-dlp version pre-check..."
# yt-dlp-precheck
check_args "$@"
