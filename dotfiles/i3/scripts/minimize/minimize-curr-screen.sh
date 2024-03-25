#!/bin/bash
wsNum=$(i3-msg -t get_workspaces | jq '.[] | select(.focused==true) | .num')
wins=$(xdotool search --all --desktop $(xprop -notype -root _NET_CURRENT_DESKTOP | cut -c 24-) "" 2>/dev/null)

if [ ! -d "/tmp/minimized-i3-windows" ]; then
    mkdir /tmp/minimized-i3-windows
fi

echo "$wins" >>/tmp/minimized-i3-windows/"$wsNum"

for id in $wins; do
    i3-msg "[id=$id] move container to workspace 10: minimized"
done
