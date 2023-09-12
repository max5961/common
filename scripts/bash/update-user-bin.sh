#!/bin/bash

source="$HOME/environment/scripts/bash/"

if [ -z "$1" ]; then
    echo -e "\033[31mError: provide at least one script to be updated from $HOME/bash to usr/local/bin\033[0m"
    echo "Optionally -a will update all scripts in the $HOME/bash directory"
    exit 1
fi

update() {
    local script=$(basename "$1")
    if [ -f "$source$script" ]; then
        local stripped_name=$(basename "$script" .sh)
        sudo cp "$source$script" /usr/local/bin/"$stripped_name" && sudo chmod +x /usr/local/bin/"$stripped_name"
        echo -e "\033[32mSuccessfully updated $script\033[0m"
    else
        echo -e "\033[31mError: $script not found in source: $source\033[0m"
    fi    
}

if [ "$1" == "-a" ]; then
    for script in "$source"*.sh; do
        update "$script"
    done
    exit 0
fi

for script in "$@"; do
    update "$script"
done
