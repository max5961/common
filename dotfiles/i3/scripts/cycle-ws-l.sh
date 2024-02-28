#!/bin/bash

# curr=$(i3-msg -t get_workspaces | jq -r '.[] | select(.focused==true) | .name')
#
# # current workspace is already at start
# if ((curr == 1 || curr == 11)); then
#     exit 0
# fi
#
# n_top=
# n_bottom=
# if ((curr > 11)); then
#     n_top=$((curr - 1))
#     n_bottom=$((n_top - 10))
# else
#     n_bottom=$((curr - 1))
#     n_top=$((n_bottom + 10))
# fi
#
# i3-msg workspace number "$n_bottom"
# i3-msg workspace number "$n_top"

curr=$(cat /tmp/current-workspace-number)
if ((curr == 1)); then
    exit 0
fi

echo $((curr - 1)) >/tmp/current-workspace-number

m1=$((curr - 1))
m2=$((curr + 9))
echo "$m2: $m1"

i3-msg workspace number "$m1"
i3-msg workspace "$m2: $m1"
