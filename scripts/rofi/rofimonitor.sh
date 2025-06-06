#!/usr/bin/env bash

# Replaces the rofi command so that the menu is opened on the current monitor
# instead of the monitor containing the mouse

MONITOR=$(i3-msg -t get_workspaces | jq '.[] | select(.focused==true).output')
rofi "${@}" -m "$MONITOR"


