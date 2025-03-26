#!/bin/bash

if [ -z "$1" ]; then
    echo "Provide a number 0 - 3 as an argument"
    exit 0
fi

echo "$1" | sudo tee /sys/class/leds/asus::kbd_backlight/brightness

