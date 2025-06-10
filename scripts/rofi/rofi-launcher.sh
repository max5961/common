#!/usr/bin/env bash

FOLDER="$HOME/common/scripts/rofi/dmenu"
SCRIPTS="$(cd $FOLDER && ls $FOLDER | sed 's/rofi-//' | sed 's/.sh//' | sort)"
CHOSEN=$(echo "$SCRIPTS" | rofimonitor -dmenu -i --matching fuzzy -p "Launcher:")
CHOSEN="$FOLDER/rofi-${CHOSEN}.sh"

[[ -f "$CHOSEN" ]] && $CHOSEN



