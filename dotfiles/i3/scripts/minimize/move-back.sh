#!/bin/bash

if [ ! -d /tmp/minimized-i3-windows ]; then
    exit 1
fi

for file in /tmp/minimized-i3-windows/*; do
    wsNum=$(basename "$file")

    while read line; do
        if ((wsNum < 11)); then
            i3-msg "[id=$line] move container to workspace $wsNum"
        elif ((wsNum < 21)); then
            name=$((wsNum - 10))
            i3-msg "[id=$line] move container to workspace $wsNum: $name"
        else
            name=$((wsNum - 20))
            i3-msg "[id=$line] move container to workspace $wsNum: $name"
        fi

    done <"/tmp/minimized-i3-windows/$wsNum"

done

for file in /tmp/minimized-i3-windows/*; do
    rm "$file"
done
