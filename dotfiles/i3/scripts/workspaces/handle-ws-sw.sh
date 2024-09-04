#!/usr/bin/env bash

mons="/tmp/connected-monitors"
rootDir="$HOME/.config/i3/scripts/workspaces"

currMonitor=$("$rootDir/get-curr-monitor.sh")
echo "$currMonitor"

primaryWs="$1"
externalWs=$((primaryWs + 10))
external2Ws=$((primaryWs + 20))
echo "$externalWs"

if grep -w 'HDMI-1-0' $mons; then
    echo "ext-mtr-sw-ws: external connected"
    i3-msg workspace "$externalWs: $primaryWs"
fi

if grep -w 'DP-1-0' $mons; then
    echo "extmtr-sw-ws: external2 connected"
    i3-msg workspace "$external2Ws: $primaryWs"
fi

i3-msg workspace "$primaryWs"

"$rootDir/switch-monitor-focus.sh" "$currMonitor"
