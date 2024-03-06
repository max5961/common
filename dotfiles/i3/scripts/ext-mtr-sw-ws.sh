#!/bin/bash

primaryWs="$1"
externalWs=$((primaryWs + 10))
echo "$externalWs"

if ! xrandr | grep 'HDMI-1-0 disconnected'; then
    echo "ext-mtr-sw-ws: external connected"
    i3-msg workspace "$externalWs: $primaryWs"
fi
