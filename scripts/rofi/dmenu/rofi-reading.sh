#!/usr/bin/env bash

READING="$HOME/Documents/Reading"
CHOSEN=$(ls $READING | rofi-monitor -dmenu -i --matching fuzzy -p "Reading:") || exit 0

zathura "$READING/$CHOSEN" >/dev/null


