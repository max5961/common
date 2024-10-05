#!/bin/bash

currTheme=$(cat ~/.config/zathura/currTheme)

function getThemes() {
    themes=""

    for theme in ~/.config/zathura/themes/*; do
        theme=$(echo "$theme" | awk -F '/' '{print $NF}')

        themes="$themes $theme"
    done

    echo $themes;
}

function sourceConfig() {
    dbus-send --system --type="method_call" --dest=org.pwmt.zathura.PID-"$1" /org/pwmt/zathura org.pwmt.zathura.SourceConfig
}

function sourceAll() {
    for pid in $(pgrep -x zathura); do
        sourceConfig $pid
    done
}

count=1
for theme in $(getThemes); do
    if [[ $theme == $currTheme ]]; then
        echo -e "$count) \033[0;32m$theme []\033[0m"
    else
        echo "$count) $theme"
    fi

    ((++count))
done

echo && read -rp "Enter number: " answer

count=1
for theme in $(getThemes); do
    if [[ $count -eq $answer ]]; then
        cp "$HOME/.config/zathura/themes/$theme" ~/.config/zathura/zathurarc
        echo "$theme" > ~/.config/zathura/currTheme
        echo -e "\nChanged theme to '\033[0;32m$theme'\033[0m"
        echo ":source or reload zathura"
        sourceAll
        exit 0
    fi
    ((++count))
done

echo "Theme not changed" && exit 1

