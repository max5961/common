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

theme=$(js-select $(getThemes) \
        --preSelectedNames="$currTheme" \
        --focusColor="green" \
        --underlineFocusText \
        --blurColor="cyan" \
        --dimBlurText \
        --borderStyle="round" \
        --borderColor="cyan" \
    )


if [[ "$theme" == "" ]]; then
    echo -e "\nNo theme selected" && exit 1
fi

cp "$HOME/.config/zathura/themes/$theme" ~/.config/zathura/zathurarc
echo "$theme" > ~/.config/zathura/currTheme
echo -e "\nChanged theme to '\033[0;32m$theme'\033[0m"
echo ":source or reload zathura"
sourceAll


