#!/usr/bin/env bash

branch=$(git rev-parse --abbrev-ref HEAD)
wip_stash="WIP_STASH: $branch"

function exit_if_error() {
    err="$?"
    [[ "$err" != 0 ]] && echo "Error: $err" && exit "$err"
}

if [[ "$1" != "save" && "$1" != "apply" ]]; then
    echo "Supply argument 'save' or 'apply'"
    exit 1
fi

if [[ "$1" == "save" ]]; then
    echo "Adding files to staging area..."
    git add .
    git stash save "$wip_stash"
else
    stash=$(git stash list | grep "$wip_stash" | awk -F ":" '{print $1}')
    echo "Applying saved stash '${stash}' / '${wip_stash}' to '${branch}'..."
    git stash apply "$stash"
    exit_if_error
    echo "Adding stashed files to staging area.."
    git add .
    echo "Removing stash..."
    git stash pop "$stash"
fi

exit_if_error


