#!/usr/bin/env bash

DIR="$HOME/Videos"

cd $DIR
VIDEO=$(fdfind --type f | awk '! /^archive/' | rofi-monitor -dmenu -i --matching fuzzy -p "Videos:") || exit 0
# mpv --force-window --idle --loop "$DIR/$VIDEO" >/dev/null 2>&1
vlc "$DIR/$VIDEO" >/dev/null 2>&1



