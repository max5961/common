#!/bin/bash

# provide at least one argument for grep to use to search for matching files
if [ -z "${1}" ]; then
    echo "Expected argument"
    exit 1
fi

# to avoid remembering exact file names, multiple arguments may be used
# grep pipes results of each argument into the next argument
alacrittyConfigDir="$HOME/common/dotfiles/alacritty"
themesDir="${alacrittyConfigDir}/dist/themes"
results=$(ls "${themesDir}" | grep "${1}")
for arg in "${@}"; do
    results=$(echo "${results}" | grep "${arg}")
done

# if there are still multiple results, get just the first
themeFile=$(echo "${results}" | head -n 1)

# if no matching theme files, exit
if [ "${themeFile}" == "" ]; then
    echo "No matching theme exists"
    exit 1
fi

# import = ["/home/max/.config/alacritty/dist/themes/rose-pine-moon.toml"]
# replace the line colorscheme import path
sed -i "s|.config/alacritty/dist/themes/.*|.config/alacritty/dist/themes/${themeFile}\"]|" "${alacrittyConfigDir}/alacritty.toml"
