#!/bin/bash

function traverse() {
    local ext="$1"
    for dirOrScript in "$2/"*; do
        if [[ -d "$dirOrScript" ]]; then
            traverse "$ext" "$dirOrScript"
        elif [[ -f "$dirOrScript" ]]; then
            move "$ext" "$dirOrScript"
        fi
    done
}

function move() {
    local ext="$1"
    local script="$2"

    if [[ ${script##*.} == "$ext" ]]; then
        local strippedName=$(basename "$script" ".$ext")
        sudo cp "$script" "/usr/local/bin/$strippedName" && sudo chmod +x "/usr/local/bin/$strippedName"

        if [ "$?" -eq 0 ]; then
            echo "Successfully updated: $strippedName"
        else
            echo "Error updating: $strippedName"
        fi
    fi

}

# $1 file extension to search for
# $2 base directory to start searching in
# NOTE: need a separate folder for js scripts to avoid trying to move js
# template and node_modules js files
traverse "sh" "$HOME/common/scripts"
traverse "js" "$HOME/common/scripts/js"
