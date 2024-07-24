#!/bin/bash

# killserver 3000

if [ -z "$1" ]; then
    echo "Enter PORT to kill connection"
    exit 1;
fi

sudo lsof -t -i :"$1" | sudo xargs kill -9

