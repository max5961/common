#!/bin/bash

if i3-msg -t get_workspaces | grep 'minimized' && ! i3-msg -t get_workspaces | grep 'focused' | grep '"visible:true"'; then
    "$HOME/.config/i3/scripts/minimize/move-back.sh"
else
    "$HOME/.config/i3/scripts/minimize/minimize-curr-screen.sh"
fi
