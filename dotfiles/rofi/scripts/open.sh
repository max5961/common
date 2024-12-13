#!/usr/bin/env bash

# This script replaces rofi command so that the menu is opened on the current monitor
# instead of the monitor containing the mouse

declare -r monitor=$(i3-msg -t get_workspaces | jq '.[] | select(.focused==true).output')
rofi "${@}" -m "$monitor"


