#!/usr/bin/env bash

echo $(xdotool search --all --desktop $(xprop -notype -root _NET_CURRENT_DESKTOP | cut -c 24-) "" 2>/dev/null)

