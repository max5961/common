#!/bin/bash

if [[ ! -d "$HOME/void" ]]; then
    mkdir ~/void
fi

cd ~/void

# Start new
if [[ -d jtest ]]; then
    if  [[ "$1" == "-n" || "$1" == "-tn" || "$1" == "-nt" ]]; then
        trash-put jtest
    fi
fi

mkdir -p jtest && cd jtest

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
    # npm init -y && npm install --save-dev @types/node
    npm init -y
    echo \
        '{
        "name": "jtest",
        "version": "1.0.0",
        "description": "",
        "scripts": {
            "start": "tsc ts-test.ts && node ts-test.js",
            "start:ts": "tsc ts-test.ts && node ts-test.js",
            "start:js": "node js-test.js"
        },
        "keywords": [],
        "author": "",
        "license": "ISC",
        "devDependencies": {
            "@types/node": "latest"
        }
    }' > package.json

    npm install
    update-package-versions
    npx prettier --write package.json
fi

touch js-test.js ts-test.ts

if [[ "$1" == "-t" || "$1" == "-tn" || "$1" == "-nt" ]]; then
    neovim ts-test.ts && exit 0;
fi

neovim js-test.js

