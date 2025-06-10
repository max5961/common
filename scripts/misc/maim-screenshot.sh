#!/usr/bin/env bash

PICTURES="$HOME/Pictures/screenshots"
FILE="screenshot-$(date '+%s%3N').png"
OUTPUT="$PICTURES/$FILE"
CMD="maim"
QUALITY=$(echo "$@" | grep -oP '\-\-quality=\d+' | grep -oP '\d+');

function monitor() {
    local currmon=$(i3-msg -t get_workspaces | jq -r '.[] | select(.focused==true) | .output')
    local imageheight=$(xrandr | grep "$currmon" | sed 's/primary//' | awk '{print $3}')

    CMD="$CMD -g $imageheight"
}

function window() {
    CMD="$CMD -i $(xdotool getactivewindow)"
}

function quality() {
    CMD="$CMD --quality $QUALITY"
}

function screenshot() {
    $CMD $OUTPUT && exit 0
}

mkdir -p $PICTURES
[[ ! -z "$QUALITY" ]] && quality
echo "$@" | grep -Pq "\-\-window" && window && screenshot
echo "$@" | grep -Pq "\-\-monitor" && monitor && screenshot
echo "$@" | grep -Pq "\-\-all" && screenshot

