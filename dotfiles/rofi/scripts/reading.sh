#!/bin/bash

declare -r READING="$HOME/Documents/Reading"

options=$(ls "$READING")
chosen=$(echo -en "$options" | rofi -dmenu -p "Reading:")

# IFS= sets the Internal Field Separator to an empty value,
# which prevents splitting the input on spaces/tabs, but
# instead on literal newline chars
# -r treats backslashes literally, not escape chars
while IFS= read -r file; do
    if [[ "$file" == "$chosen" ]]; then
        nohup zathura "$READING/$file" >/dev/null 2>&1 &
    fi
done <<< "$options"


