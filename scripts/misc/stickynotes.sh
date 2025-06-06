#!/usr/bin/env bash

STICKYNOTES="$HOME/.stickynotes"
cd "$STICKYNOTES"

NEW="⎘ new "
EXPLORER="🌐 explorer"
LIST="${NEW}\n${EXPLORER}\n$(mkdir -p $STICKYNOTES && ls $STICKYNOTES)"

chosen="$(echo -en "$LIST" | rofimonitor -dmenu -i --matching fuzzy -p "Notes:")"

function new_note() {
    local name=$(rofimonitor -dmenu -p "Name:" --allow-custom true)
    [[ -z $name ]] && name=$(date "+%F_%H:%M:%S")
    local file="$STICKYNOTES/${name}.md"
    echo -en "# $name" > $file
    local file_contents=$(cat $file)

    kitty --execute "$EDITOR" "$file" 2>&1
    [[ "$(<$file)" == "$file_contents" ]] && rm "$file"
}

function explorer() {
    kitty --execute "$EDITOR" "$STICKYNOTES" 2>&1
}

function markdown() {
    kitty --execute "$EDITOR" "$STICKYNOTES/${chosen}" 2>&1
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
