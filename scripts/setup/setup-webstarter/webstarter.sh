#!/bin/bash

dest="$(pwd)"
webstarter="/home/max/common/scripts/setup/setup-webstarter/template/"
css_reset="$HOME/common/templates/css-resets/reset.css"

if [ ! -d "$webstarter" ]; then
    echo -e "\033[31mError: webstarter template does not exist in: $webstarter\033[0m"
    exit 1
fi

cd "$webstarter" && cp -r ./. "$dest"
cd "$dest"

if [ ! -f "$css_reset" ]; then
    echo -e "\033[33mCannot locate css reset\033[0m"
    echo "style.css file will be left empty"
else
    cat "$css_reset" >./style.css
fi

echo "Created HTML, CSS, JS template"
echo "For live website reloads run:"
echo "browser-sync start --server --file --watch '*'"

# For some reason, LSP autosuggestions won't work unless stylelist-lsp
# is installed LOCALLY
npm init -y
npm install --save-dev stylelint-lsp

git init
