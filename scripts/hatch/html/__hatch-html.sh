#!/bin/bash

DEST="$1"
NEW="$2"
TEMPLATE="$HOME/common/scripts/hatch/html/template"
CSS_RESET="$HOME/common/templates/css-resets/reset.css"

mkdir -p "$DEST" && cd "$DEST"

if [[ "$NEW" || -z "$(ls -A $DEST)" ]]; then
    cp -r "$TEMPLATE"/* "$DEST"

    if [ ! -f "$CSS_RESET" ]; then
        echo "Cannot locate css reset"
    else
        cat "$CSS_RESET" >./style.css
    fi

    # For some reason, LSP autosuggestions won't work unless stylelist-lsp
    # is installed LOCALLY
    npm init -y
    npm install --save-dev stylelint-lsp
    git init
    echo "node_modules/" >> .gitignore

    echo "Created HTML, CSS, JS template"
    echo "For live website reloads run:"
    echo "browser-sync start --server --file --watch '*'"
fi

$EDITOR index.html



