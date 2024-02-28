#!/bin/bash

curr=$(i3-msg -t get_workspaces | jq -r '.[] | select(.focused==true) | .name')

# current workspace is already at end
if ((curr == 9 || curr == 19)); then
    exit 0
fi

n_top=
n_bottom=
if ((curr > 10)); then
    n_top=$((curr + 1))
    n_bottom=$((n_top - 10))
else
    n_bottom=$((curr + 1))
    n_top=$((n_bottom + 10))
fi

i3-msg workspace number "$n_bottom"
i3-msg workspace number "$n_top"
