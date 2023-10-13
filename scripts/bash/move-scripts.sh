#!/bin/bash

function update() {
    local script="${1}"
    local script_name=$(basename "${script}")
    local stripped_name=$(basename "${script_name}" .sh)
    sudo cp "${script}" /usr/local/bin/"${stripped_name}" && sudo chmod +x /usr/local/bin/"${stripped_name}"
    
    if [ $? -eq 0 ]; then
        echo "Successfully updated: ${script_name}"
    else
        echo "Unsuccessful update of: ${script_name}"
    fi
}

function find_scripts() {
    local source="${1}"
    
    for dir_or_script in "${source}"*
    do
        if [ -d "${dir_or_script}" ]; then
            find_scripts "${dir_or_script}/"
        elif [ -f "${dir_or_script}" ]; then
            update "${dir_or_script}"
        fi
    done
}

if [ "${1}" = "--help" ]; then
    echo "Moves scripts /usr/local/bin/ and strips the name so that they can be run globally "
    echo "-s: pass a single script to be updated"
    echo "-d: pass a single directory to update all scripts within the directory"
    echo "no args: update every script within ~/environment/scripts/bash/"

elif [ "${1}" = "-s" ]; then
    if [ -f "${2}" ]; then
        for script in "$@"
        do
            if [ ! "${script}" = "-s" ]; then
                update "${script}"
            fi
        done
    fi
    
elif [ "${1}" = "-d" ]; then
    if [ -d "${2}" ]; then
        find_scripts "${2}"
    fi

else
    find_scripts "/home/max/environment/scripts/bash/"
fi

