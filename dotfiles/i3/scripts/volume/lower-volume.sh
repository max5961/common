#!/bin/bash

pactl set-sink-volume @DEFAULT_SINK@ -2%

if pactl get-sink-volume @DEFAULT_SINK@ | grep -E "Volume:[^1-9]+00?%"; then
    pactl set-sink-mute @DEFAULT_SINK@ true
fi
