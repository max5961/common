#!/usr/bin/env bash

declare -r file="/tmp/connected-monitors"

if [[ -f $file ]]; then
    rm $file
fi
touch $file

monitors=(
    $(xrandr | grep -w "eDP-1 connected" | awk '{print $1}') \
        $(xrandr | grep -w "DP-1-0 connected" | awk '{print $1}') \
        $(xrandr | grep -w "HDMI-1-0 connected" | awk '{print $1}') \
    )

for mon in ${monitors[@]}; do
    if [[ ! $mon == "" ]]; then
        echo $mon >> $file
    fi
done
