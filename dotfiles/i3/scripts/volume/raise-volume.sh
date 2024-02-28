#!/bin/bash

if pactl get-sink-mute @DEFAULT_SINK@ | grep "yes"; then
    pactl set-sink-mute @DEFAULT_SINK@ false
fi

echo "$CUSTOM_VOLUME_STEP"
pactl set-sink-volume @DEFAULT_SINK@ +2%
