#!/bin/bash

rootDir="$HOME/.config/i3/scripts/workspaces"

currMonitor=$("$rootDir/get-curr-monitor.sh")
echo "$currMonitor"

primaryWs="$1"
externalWs=$((primaryWs + 10))
echo "$externalWs"

if ! xrandr | grep 'HDMI-1-0 disconnected'; then
    echo "ext-mtr-sw-ws: external connected"
    i3-msg workspace "$externalWs: $primaryWs"
fi

i3-msg workspace "$primaryWs"

"$rootDir/switch-monitor-focus.sh" "$currMonitor"
