#!/bin/bash

[[ -z "$1" ]] && echo "Provide a number 0-3 as an argument" && exit 0;
echo "$1" | sudo tee /sys/class/leds/asus::kbd_backlight/brightness



