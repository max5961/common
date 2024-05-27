#!/bin/bash

# Terminate already running bar instances
# If all your bars have ipc enabled, you can use
# polybar-msg cmd quit
# Otherwise you can use the nuclear option:
killall -q polybar

# Launch bar1 and bar2
echo "---" | tee -a /tmp/polybar-main.log /tmp/polybar-main.log
polybar main 2>&1 | tee -a /tmp/polybar-main.log &

if ! xrandr | grep 'HDMI-1-0 disconnected'; then
	polybar external1 2>&1 | tee -a /tmp/polybar-external1.log /tmp/polybar-external1.log
fi

if ! xrandr | grep 'DP-1-0 disconnected'; then
	polybar external2 2>&1 | tee -a /tmp/polybar-external2.log /tmp/polybar-external2.log
fi

disown

echo "Bars launched..."
