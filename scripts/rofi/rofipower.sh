#!/usr/bin/env bash

LOCK_SCREEN="🔒    Lock Screen"
NEW_XSESSION="⎘    New Xsession"
REBOOT="⟳    Reboot"
POWER_OFF="⏻    Power Off"

OPTS="${LOCK_SCREEN}\n${NEW_XSESSION}\n${REBOOT}\n${POWER_OFF}"
CHOSEN=$(echo -en "$OPTS" | rofimonitor -dmenu -i --matching fuzzy -p "Power Menu:") || exit 0

case $CHOSEN in
    $LOCK_SCREEN)
        dm-tool switch-to-greeter
        ;;
    $NEW_XSESSION)
        i3-msg exit
        ;;
    $REBOOT)
        systemctl reboot
        ;;
    $POWER_OFF)
        systemctl poweroff
        ;;
    *)
        exit 0
        ;;
esac

