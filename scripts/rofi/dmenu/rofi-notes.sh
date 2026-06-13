#!/usr/bin/env bash

NOTES="$HOME/Documents/notes"
CONTENTS=$(ls -A "$NOTES" | sort )

CHOSEN=$(echo -en "$CONTENTS" | rofimonitor -dmenu -i --matching fuzzy -p "Notes:")

cd "$NOTES/$CHOSEN"
kitty --execute lf "$NOTES/$CHOSEN" 2>&1



