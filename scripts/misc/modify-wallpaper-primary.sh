#!/usr/bin/env bash

if [[ -z "$1" ]]; then
    echo "Unprovided file"
    exit 1
fi

# primary
nitrogen --head=0 --save --set-zoom-fill "$1"
exit 0

