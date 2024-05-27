#!/bin/bash

if xrandr | grep 'HDMI-1-0 disconnected'; then
	xrandr --output eDP-1 --primary --mode 1920x1080 --pos 0x1080 --rotate normal --output DP-1-0 --off --output DP-1-1 --off

	# modify alacritty font size
	perl -i -0pe 's/(\[font\]\nsize\s?=\s?).+/${1}8.5/' ~/.config/alacritty/alacritty.toml
else
	# xrandr --output eDP-1 --primary --mode 1920x1080 --pos 0x1080 --rotate normal --output DP-1-0 --off --output DP-1-1 --off --output HDMI-1-0 --mode 1920x1080 --pos 0x0 --rotate normal
	# xrandr --output eDP-1 --primary --mode 1920x1080 --pos 0x0 --rotate normal --output DP-1-0 --off --output DP-1-1 --off --output HDMI-1-0 --mode 1920x1080 --pos 1920x0 --rotate normal
	xrandr --output eDP-1 --primary --mode 1920x1080 --pos 0x0 --rotate normal --output DP-1-0 --mode 1920x1080 --pos 1920x0 --rotate normal --output DP-1-1 --off --output HDMI-1-0 --mode 1600x900 --pos 1920x1080 --rotate normal

	# modify alacritty font size
	perl -i -0pe 's/(\[font\]\nsize\s?=\s?).+/${1}11.75/' ~/.config/alacritty/alacritty.toml
fi
