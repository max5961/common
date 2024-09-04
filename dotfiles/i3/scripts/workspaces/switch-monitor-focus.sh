#!/usr/bin/env bash

# needs some time for everything to properly load
sleep 0.1
i3-msg focus output "$1"
