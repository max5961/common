#!/usr/bin/env bash

function workspaceStart() {
    if (( "$1" < 10 )); then
        echo 1;
    fi

    if (( "$1" >= 11 && "$1" <= 19 )); then
        echo 11
    fi

    if (( "$1" >= 21 && "$1" <= 29 )); then
        echo 21
    fi
}

if [[ -z "$1" || -z "$2" ]]; then
    echo "Unprovided arguments"; exit 1;
fi

declare -r currWindow=$("$HOME/.config/i3/scripts/move-windows/get-curr-window.sh")
declare -r allWindows=$("$HOME/.config/i3/scripts/move-windows/get-all-windows-on-screen.sh")
declare -r currWorkspace=$("$HOME/.config/i3/scripts/move-windows/get-curr-workspace.sh")

declare wins=""

if [[ "$1" == "--all" ]]; then
    wins="$allWindows"
elif [[ "$1" == "--single" ]]; then
    wins="$currWindow"
else
    echo "Invalid argument"; exit 1;
fi

declare -r start=$(workspaceStart "$currWorkspace")
declare -r targetName="$2"
declare -r target=$(($targetName + start - 1));

echo $start
echo $target

for id in $wins; do
    i3-msg "[id=$id] move container to workspace $target: $targetName"
done

if [[ "$3" == "--sw-post" ]]; then
    "$HOME/.config/i3/scripts/workspaces/handle-ws-sw.sh" "$targetName"
fi

