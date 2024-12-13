#!/bin/bash

declare -r OPEN_SCRIPT="$HOME/.config/rofi/scripts/open.sh"

# power options
opt0="logout"
opt1="suspend"
opt2="reboot"
opt3="shutdown"

options="$opt0\n$opt1\n$opt2\n$opt3\n"

chosen=$(echo -en "$options" | "$OPEN_SCRIPT" -dmenu -p "Power Menu:")
case $chosen in
    $opt0)
        i3-msg exit
        ;;
    $opt1)
        systemctl suspend
        ;;
    $opt2)
        systemctl reboot
        ;;
    $opt3)
        systemctl poweroff
        ;;
esac
