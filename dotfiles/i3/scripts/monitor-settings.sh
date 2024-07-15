#!/bin/sh

if xrandr | grep 'HDMI-1-0 connected'; then
    sleep 3
    xrandr --output eDP-1 --primary --mode 1920x1080 --pos 0x0 --rotate normal --output DP-1-0 --mode 1920x1080 --pos 1920x0 --rotate normal --output DP-1-1 --off --output HDMI-1-0 --mode 1600x900 --pos 1920x1080 --rotate normal
else
    "$HOME/.screenlayout/no-external.sh"
fi

# xrandr --output eDP-1 --primary --mode 1920x1080 --pos 0x0 --rotate normal --output DP-1-0 --mode 1920x1080 --pos 1920x0 --rotate normal --output DP-1-1 --off --output HDMI-1-0 --mode 1600x900 --pos 1920x1080 --rotate normal

