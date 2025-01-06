#!/usr/bin/env bash

# Moves theme files to to their respective dotfiles location
# This way theme files can be git ignored, but the templates can be tracked.

# Destination locations
i3_dest="$HOME/.config/i3"
kitty_dest="$HOME/.config/kitty"
nvim_dest="$HOME/.config/nvim/lua"
picom_dest="$HOME/.config/picom"
polybar_dest="$HOME/.config/polybar"
rofi_dest="$HOME/.config/rofi"

# Target files
i3_target="./i3/colors.conf"
kitty_target="./kitty/theme.conf"
nvim_target="./nvim/colorscheme.lua"
picom_target="./picom/picom.conf"
polybar_target="./polybar/theme.ini"
rofi_target="./rofi/colors.rasi"

cp "$i3_target" "$i3_dest"
cp "$kitty_target" "$kitty_dest"
cp "$nvim_target" "$nvim_dest"
cp "$picom_target" "$picom_dest"
cp "$polybar_target" "$polybar_dest"
cp "$rofi_target" "$rofi_dest"
