#!/usr/bin/env bash

playing=$(mpc status | grep 'playing')
paused=$(mpc status | grep 'paused')
if [[ ! "$playing"  && ! "$paused" ]]; then
    mpd
    mpc play
    exit 0
fi

if mpc | grep -q playing; then
    mpc pause
else
    mpc play
fi
