#!/usr/bin/env bash

DEST="$1"
NEW="$2"
TEMPLATE="$HOME/common/scripts/hatch/ts/template"

mkdir -p "$DEST" && cd "$DEST"

if [[ "$NEW" || -z "$(ls -A)" ]]; then
    shopt -s dotglob
    rm -rf $DEST/*
    cp -r "$TEMPLATE"/* .
    shopt -u dotglob

    npm init -y &> /dev/null
    git init
    echo "node_modules/" >> "$DEST/.gitignore"
    echo "*.log" >> "$DEST/.gitignore"
    npm install
    npx prettier --write ./*
    update-package-versions
fi

$EDITOR src/index.ts && exit 0


