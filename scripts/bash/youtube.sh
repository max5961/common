#!/bin/bash

is_up_to_date() {
    local latest="$(pacman -Ss yt-dlp | awk 'NR==1 {print $2}' | awk -F- '{print $1}')"
    local current="$(yt-dlp --version)"

    if [ "$latest" == "$current" ]; then
        return 0
    else
        return 1
    fi
}

to_lower_case() {
	echo "$1" | tr [:upper:] [:lower:]
}

input_not_empty() {
    if [ -z "$1" ]; then
        return 1
    else
        return 0
    fi
}

get_full_path_link() {
    if echo "$1" | grep -q "https://"; then
        printf "$1"
    else
        printf "https://$1"
    fi
}

# check if empty input
if ! input_not_empty "$1"; then
    echo "Error: no URL added"
    exit 1
fi

# ensure URL has full https:// path
URL="$(get_full_path_link "$1")"
echo "$URL"

# get latest version of yt-dlp
if ! is_up_to_date; then
    echo "yt-dlp is not up to date and may not work as intended."
    read -p "Upgrade to the latest version? [y/n]" upgrade
    if [ "$(to_lower_case "$upgrade")" == "y" ] || [ "$(to_lower_case "$upgrade")" == "" ]; then
        sudo pacman -S yt-dlp
    fi
fi

# get user configuration
read -p "Audio or Video? [a/v]:" format
format="$(to_lower_case "$format")"
if [ ! "$format" == "a" ] && [ ! "$format" == "v" ]; then
    echo "Invalid entry"
    exit 1
fi

read -p "Playlist? [y/n]:" playlist
playlist="$(to_lower_case "$playlist")"
if [ ! "$playlist" == "y" ] && [ ! "$playlist" == "n" ]; then
    echo "Invalid entry"
    exit 1
fi

create_dl_folder() {
    if [ ! -d "$1" ]; then
       if [ echo "$1" | grep Music ]; then
            cd
            mkdir -p Music/yt-dlp
        else
            cd
            mkdir -p Videos/yt-dlp
        fi
    fi
}

dl_to_custom_playlist_folder() {
    # already in either Music or Videos directories
    if pwd | grep -q "Music"; then

    # Music
        cd "$HOME/Music/"
        read -p "Artist name:" artist
        if [ -z "$artist" ]; then
            echo "Artist name empty.  Creating default download folder in..." && pwd
            dl_to_default_playlist_folder "$URL"
            exit 0
        else
            mkdir "$artist" && cd "$artist"
        fi
        read -p "Album name:" album
        if [ -z "$album" ]; then
            echo "Album name empty.  Creating default download folder in..." && pwd
            dl_to_custom_playlist_folder "$URL"
            exit 0
        else
            mkdir "$album" && cd "$album"
        fi

        yt-dlp -f bestaudio "$URL"

    # Videos
    else
        cd "$HOME/Videos/"
        read -p "Download to... $(pwd)/" filepath
        downloading to "$filepath"
        mkdir -p "$filepath" && cd "$filepath"
        
        yt-dlp -f bestaudio+bestvideo "$URL"
    fi
}

handle_playlist_dir() {
    read -p "Create custom folder? [y/n]:" answer
    answer="$(to_lower_case "$answer")"
    if [ "$answer" == "y" ] || [ "$answer" == "" ]; then
        dl_to_custom_playlist_folder
    else
        dl_to_default_playlist_folder
    fi
}

dl_to_default_playlist_folder() {
    new_dir="$(date +"%d-%m-%Y-%H-%M-%S")"
    mkdir "$new_dir" && cd "$new_dir"
    # check if in Music or Videos dir
    if echo pwd | grep -q "Music"; then
        yt-dlp bestaudio "$1"
    else
        yt-dlp bestaudio+bestvideo "$1"
    fi
}

# check for destination directories.  If not, build them
Music_yt_dlp="$HOME/Music/yt-dlp/"
Videos_yt_dlp="$HOME/Videos/yt-dlp"

# audio
if [ "$format" == "a" ]; then
    create_dl_folder "$Music_yt_dlp"
    cd "$Music_yt_dlp"

    # no playlist
    if [ "$playlist" == "n" ]; then
        yt-dlp -f bestaudio --no-playlist "$URL"
        echo "downloaded to: $(pwd)"
    # playlist
    else
        handle_playlist_dir
    fi

# video
else
    create_dl_folder "$Videos_yt_dlp"
    cd "$Videos_yt_dlp"
    
    # no playlist
    if [ "$playlist" == "n" ]; then
        yt-dlp -f bestaudio+bestvideo --no-playlist "$URL"
        echo "downloaded to: $(pwd)"
    # playlist
    else
        handle_playlist_dir
    fi
fi

