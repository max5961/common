#!/usr/bin/env bash

[[ -z "$1" ]] && echo "Provide a name" && exit 1

STORAGE_LOC="$HOME/.cache/saved-wal"
CURRENT_LOC="$HOME/.cache/wal"

mkdir -p "$STORAGE_LOC"
cp -r "$CURRENT_LOC" "$STORAGE_LOC/${1}"
[[ "$?" -eq 0 ]] && echo "Saved to ${STORAGE_LOC}/${1}"





