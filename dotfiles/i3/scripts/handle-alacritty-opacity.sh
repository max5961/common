#!/bin/bash

# In order for this script to work correctly, the value set in the alacritty
# config must be 10% or above, and must be in the format of 0.10 or 1 for fully
# opaque. This is because bash can't handle decimals or handle ints formatted
# with leading zeros and handling those edge cases would be more trouble than
# simply making sure any modification outside of this script conforms to the
# specified format

# pass in -d to decrease, -i to increase
increase=true
if [ "$1" == "-d" ]; then
    increase=false
elif [ "$1" == "-i" ]; then
    increase=true
fi

# get current opacity as an integer 10-99 or 1 for fully opaque
curr=$(cat ~/.config/alacritty/alacritty.toml | pcregrep -o1 "opacity\s*=\s*[0-9]*\.*([0-9]+)")

# check for edge cases
if "$increase" && ((curr == 1)); then
    exit 0
fi
if ! "$increase" && ((curr == 10)); then
    exit 0
fi

# handle increment or decrement
if [ "$increase" == true ]; then
    curr=$((curr + 1))

    if ((curr == 100)); then
        curr="1"
    else
        curr="0.$curr"
    fi

else
    if ((curr == 1)); then
        curr=100
    fi

    curr="0.$((curr - 1))"
fi

# modify config file in place
sed -i "s/opacity\s\=*.*/opacity = $curr/" ~/.config/alacritty/alacritty.toml
