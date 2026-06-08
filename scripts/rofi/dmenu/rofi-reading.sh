#!/usr/bin/env bash

READING="$HOME/Documents/reading"
CHOSEN=$(ls $READING | rofi-monitor -dmenu -i --matching fuzzy -p "Reading:") || exit 0

zathura "$READING/$CHOSEN" >/dev/null
