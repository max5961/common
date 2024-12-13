#!/usr/bin/env bash

# Wrapper for Rofi to make sure that it opens in focused monitor
declare -r OPEN_SCRIPT="$HOME/.config/rofi/scripts/open.sh"
# Used as a stop point when going back directories
declare -r BASE_READING="$HOME/Documents/Reading"
declare -r BACK_ONE_DIR="../"
declare -r DIR_ICON=" "
declare -r FILE_ICON=" "
declare -r PDF_ICON="󰈦 "
# declare -r PDF_ICON=" "

declare options=""
function getOptions() {
    local reading="$1"
    IFS=$'\n'

    local unorderedOptions=$(ls -L "$reading")

    local directories=""
    for opt in $unorderedOptions; do
        if [[ -d "$reading/$opt" ]]; then
            directories="$directories$DIR_ICON$opt/"$'\n'
        fi
    done

    local files=""
    for opt in $unorderedOptions; do
        if [[ -f "$reading/$opt" ]]; then
            local icon="$FILE_ICON"

            if [[ "${opt##*.}" == "pdf" ]]; then
                icon="$PDF_ICON"
            fi

            files="$files$icon$opt"$'\n'
        fi
    done

    options="$directories$files"

    if [[ "$reading" != "$BASE_READING" ]]; then
        options="$BACK_ONE_DIR"$'\n'"$options"
    fi
}

function listDirectory() {
    local reading="$1"
    getOptions "$reading"

    local chosen=$(echo -en "$options" | "$OPEN_SCRIPT" -dmenu -p "$reading:")

    while IFS= read -r file; do
        # Esc has been pressed and no file is selected.  Exit Rofi
        if [[ -z "$file" ]]; then
            return;
        fi

        # No file is chosen yet, continue
        if [[ "$file" != "$chosen" ]]; then
            continue
        fi

        #
        if [[ "$file" == "$BACK_ONE_DIR" ]]; then
            listDirectory "${reading%/*}"
            return
        fi

        # $options includes a leading trailing forward slash for directories and a
        # leading icon for all options.  Remove these as they are for visual feedback only
        file=${file%/}
        file=${file#$FILE_ICON}
        file=${file#$DIR_ICON}
        file=${file#$PDF_ICON}

        # Next chosen directory
        if [[ -d "$reading/$file" ]]; then
            listDirectory "$reading/$file"
            return
        fi

        # Open file in Zathura
        if [[ -f "$reading/$file" ]]; then
            nohup zathura "$reading/$file" >/dev/null 2>&1 &
            return
        fi
    done <<< "$options"
}

listDirectory "$BASE_READING"
