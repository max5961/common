#!/bin/bash

cd ~/void

# Start new
if [[ -d js-test ]]; then
    if  [[ "$1" == "-n" || "$1" == "-tn" || "$1" == "-nt" ]]; then
        trash-put js-test
    fi
fi

mkdir -p js-test && cd js-test

if [[ ! -f .prettierrc.json ]]; then
    cp ~/common/templates/dotfiles/.prettierrc.json .
fi

if [[ ! -f .gitignore ]]; then
    echo "node_modules/" >> .gitignore
fi

if [[ ! -d .git ]]; then
    git init > /dev/null 2>&1
fi

if [[ ! -d node_modules ]]; then
    npm init -y && npm install --save-dev @types/node
fi

touch js-test.js ts-test.ts

if [[ "$1" == "-t" || "$1" == "-tn" || "$1" == "-nt" ]]; then
    neovim js-test.ts && exit 0;
fi

neovim js-test.js

