#!/usr/bin/env bash

branch=$(git branch --show-current)
wip_stash="WIP_STASH: $branch"

function exit_if_error() {
    [[ "$?" != 0 ]] && exit "$?"
}
function namespace_echo() {
    echo -e "\e[0;36mwipstash: $1\e[0m"
}
function get_stash() {
    stash=$(git stash list | grep -F "$wip_stash" | awk -F ":" '{print $1}')
    echo "$stash"
}

if [[ "$1" != "save" && "$1" != "apply" ]]; then
    echo "Supply argument 'save' or 'apply'"
    exit 1
fi

if [[ "$1" == "save" ]]; then
    namespace_echo "Adding files to staging area"
    git add .
    stash=$(get_stash)
    if [[ "$stash" != "" ]]; then
        namespace_echo "Stash '${stash}' already exists"
        exit 1
    fi
    git stash save "$wip_stash"
else
    stash=$(get_stash)
    if [[ "$stash" != "" ]]; then
        namespace_echo "Applying stash ${stash}"
    else
        namespace_echo "No stash for branch: $branch"
        exit 1
    fi

    git stash apply "$stash"
    exit_if_error
    namespace_echo "'${stash}' / '${wip_stash}' applied to branch: '${branch}'"

    namespace_echo "Adding stashed files to staging area"
    git add .

    namespace_echo "Dropping stash '${wip_stash}'"
    git stash pop "$stash"
fi

exit_if_error


