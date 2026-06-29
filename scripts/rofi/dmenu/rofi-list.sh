#!/usr/bin/env bash

NOTEPAD="$HOME/.stickynotes"
cd "$NOTEPAD"

NEW="⎘ new "
EXPLORER="🌐 explorer"
LIST="${NEW}\n${EXPLORER}\n$(mkdir -p $NOTEPAD && ls $NOTEPAD)"

chosen=$(echo -en "$LIST" | rofimonitor -dmenu -i --matching fuzzy -p "Notes:") || exit 0

function new_note() {
    local name=$(rofi-monitor -dmenu -p "Name:" --allow-custom true)
    [[ -z $name ]] && name=$(date "+%F_%H:%M:%S")
    local file="$NOTEPAD/${name}.md"
    echo -en "# $name" > $file
    local file_contents=$(cat $file)

    kitty --execute "$EDITOR" "$file" 2>&1
    [[ "$(<$file)" == "$file_contents" ]] && rm "$file"
}

function explorer() {
    kitty --execute "$EDITOR" "$NOTEPAD" 2>&1
}

function markdown() {
    kitty --execute "$EDITOR" "$NOTEPAD/${chosen}" 2>&1
}

case $chosen in
    $NEW)
        new_note
        ;;
    $EXPLORER)
        explorer
        ;;
    *.md)
        markdown
        ;;
    *)
        exit 0
        ;;
esac
