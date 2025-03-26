#!/bin/bash

declare -r screenshotsDir="$HOME/Pictures/screenshots"
declare -r fileName="screenshot-$(date '+%s%3N').png"
declare -r output="$screenshotsDir/$fileName"

mkdir -p "$screenshotsDir"

cmdPrefix="maim"

# For best quality but significantly slower screenshot times:
# cmdPrefix="maim --quality 10"

if [[ "$1" == "--window" ]]; then
    cmdPrefix="$cmdPrefix -i $(xdotool getactivewindow)"
fi

if [[ "$1" == "--monitor" ]]; then
    declare -r currMon=$(i3-msg -t get_workspaces | jq -r '.[] | select(.focused==true) | .output')

    declare -r line=$(xrandr | grep "$currMon")
    declare coords=$(echo $line | awk '{print $3}')

    if echo $line | grep "primary"; then
        coords=$(echo $line | awk '{print $4}')
    fi
    cmdPrefix="$cmdPrefix -g $coords"
fi


$cmdPrefix $output





