#!/bin/bash

rootDir="$HOME/.config/i3/scripts/workspaces"

currMonitor=$("$rootDir/get-curr-monitor.sh")
echo "$currMonitor"

curr=$(cat /tmp/current-workspace-number)
if ((curr == 1)); then
    exit 0
fi

echo $((curr - 1)) >/tmp/current-workspace-number

m1=$((curr - 1))
m2=$((curr + 9))
m3=$((curr + 19))
echo "$m2: $m1"

i3-msg workspace number "$m1"
if ! xrandr | grep 'HDMI-1-0 disconnected'; then
    echo "cycle-ws-l: external connected"
    i3-msg workspace "$m2: $m1"
fi

if ! xrandr | grep 'DP-1-0 disconnected'; then
    echo "cycle-ws-r: external DP-1-1 connected"
    i3-msg workspace "$m3: $m1"
fi

"$rootDir/switch-monitor-focus.sh" "$currMonitor"
