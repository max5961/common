#!/bin/bash

function open_app() {
    nohup "$1" >/dev/null 2>&1 &
}

brave="Brave"
firefox="Firefox"
file_explorer="File Explorer"
bit_warden="Bitwarden"
calc="Calulator"
pulseaudio="Pulse Audio Volume Control"
nitrogen="Nitrogen"
screenshot="Gscreenshot"
gimp="Gimp"
bluetooth="Bluetooth"
network_manager="Network Manager (nmtui)"

options="$brave\n$firefox\n$file_explorer\n$bit_warden\n$calc\n$pulseaudio\n$nitrogen\n$screenshot\n$gimp\n$bluetooth\n$network_manager"

chosen=$(echo -en $options | rofi -dmenu -i -p "Favorite Applications:")
case $chosen in
    $brave)
        open_app "brave"
        ;;
    $firefox)
        open_app "firefox"
        ;;
    $file_explorer)
        open_app "nautilus"
        ;;
    $bit_warden)
        open_app "bitwarden-desktop"
        ;;
    $calc)
        open_app "gnome-calculator"
        ;;
    $pulseaudio)
        open_app "pavucontrol"
        ;;
    $nitrogen)
        open_app "nitrogen"
        ;;
    $screenshot)
        open_app "gscreenshot"
        ;;
    $gimp)
        open_app "gimp"
        ;;
    $bluetooth)
        open_app "blueberry"
        ;;
    $network_manager)
        alacritty -e nmtui
        ;;
esac
