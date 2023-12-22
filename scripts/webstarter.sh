#!/bin/bash

dest="$(pwd)"
webstarter="$HOME/common/resources/templates/webstarter/"
css_reset="$HOME/common/resources/templates/css-resets/reset.css"

if [ ! -d "$webstarter" ]; then
    echo -e "\033[31mError: webstarter template does not exist in: $webstarter\033[0m"
    exit 1
fi

cd "$webstarter" && cp -r ./* "$dest"
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
