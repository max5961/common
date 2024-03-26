#!/bin/bash

# check if already running
tmpfile="/tmp/persist-reboots"
if [[ -f "$tmpfile" ]]; then
    exit 0
else
    touch "$tmpfile"
fi

restore_tmux_environment="$HOME/.config/tmux/plugins/tmux-resurrect/scripts/restore.sh"
save_tmux_environment="$HOME/.config/tmux/plugins/tmux-resurrect/scripts/save.sh"

"$restore_tmux_environment"

while true; do
    # save environment every 15 minutes
    sleep 900
    if tmux list-sessions &>/dev/null; then
        "$save_tmux_environment"
    else
        rm "$tmpfile"
        exit 0
    fi
done
