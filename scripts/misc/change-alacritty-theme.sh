#!/bin/bash

alacrittyConfigDir="$HOME/common/dotfiles/alacritty"
themesDir="${alacrittyConfigDir}/dist/themes"

# provide at least one argument
# otherwise list available themes
if [ -z "${1}" ] || [ "${1}" == "--themes" ]; then
    ls "${themesDir}"
    exit 0
fi

# search for themes with -g
if [ "${1}" == "-g" ]; then
    if [ -z "${2}" ]; then
        echo "Expected search term"
        exit 1
    else
        echo $(ls "${themesDir}" | grep "${2}")
        exit 0
    fi
fi

### main
# to avoid remembering exact file names, multiple arguments may be used
# grep pipes results of each argument into the next argument
results=$(ls "${themesDir}" | grep -i "${1}")
for arg in "${@}"; do
    results=$(echo "${results}" | grep -i "${arg}")
done

# if there are still multiple results, get just the first
themeFile=$(echo "${results}" | head -n 1)

# if no matching theme files, exit
if [ "${themeFile}" == "" ]; then
    echo "No matching theme exists"
    exit 1
fi

# replace the line colorscheme import path
sed -i "s|.config/alacritty/dist/themes/.*|.config/alacritty/dist/themes/${themeFile}\"]|" "${alacrittyConfigDir}/alacritty.toml"
