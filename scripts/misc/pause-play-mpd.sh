#!/bin/bash

if ! mpc status; then
    mpd
    mpc play
    exit 0
fi

if mpc | grep -q playing; then
    mpc pause
else
    mpc play
fi
