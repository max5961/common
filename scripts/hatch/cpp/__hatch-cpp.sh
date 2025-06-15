#!/usr/bin/env bash

DEST="$1"
NEW="$2"
TEMPLATE="$HOME/common/scripts/hatch/cpp/template"

mkdir -p "$DEST" && cd "$DEST"

if [[ "$NEW" || -z "$(ls -A)" ]]; then
    rm -rf "$DEST"/.* "$DEST"/*
    cp -r "$TEMPLATE"/* .
    cp -r "$TEMPLATE"/.* .
fi

$EDITOR src/main.cpp && exit 0




