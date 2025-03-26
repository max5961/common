#!/usr/bin/env bash

DIR="$HOME/void/jtest"
PRETTIER="$HOME/common/templates/dotfiles/.prettierrc.json"
TSCONFIG_BASE="$HOME/common/templates/tsconfig-base.json"
TSCONFIG='{
    "extends": "./tsconfig-base.json"
}'
PACKAGE='{
    "name": "jtest",
    "version": "1.0.0",
    "description": "",
    "main": "./dist/index.js",
    "exports": {
        "types": "./dist/index.d.ts",
        "default": "./dist/index.js"
    },
    "scripts": {
        "start": "tsc && node ./dist/index.js",
        "test": "tsc && npx vitest"
    },
    "type": "module",
    "keywords": [],
    "author": "",
    "license": "MIT",
    "devDependencies": {
        "@mmorrissey5961/directlink": "^1.0.0",
        "@types/node": "^22.13.13",
        "vitest": "^3.0.9"
    }
}'
TEST_SUITE='import { describe, test, expect } from "vitest";

describe("Foo", () => {
        test("foo", () => {
                expect("foo").toBe("foo");
        });
});'



mkdir -p "$DIR" && cd "$DIR"

if [[ "$1" == "-n" || "$1" == "--new" || -z "$(ls -A $DIR)" ]]; then
    cd ../ && rm -rf "$DIR" && mkdir "$DIR" && cd "$DIR"
    npm init -y &> /dev/null
    git init
    mkdir "$DIR/src" && touch "$DIR/src/index.ts"
    mkdir "$DIR/test" && touch "$DIR/test/test.spec.ts"
    cp "$PRETTIER" .
    cp "$TSCONFIG_BASE" .
    echo "$PACKAGE" > "$DIR/package.json"
    echo "$TSCONFIG" > "$DIR/tsconfig.json"
    echo "$TEST_SUITE" > "$DIR/test/test.spec.ts"
    echo "node_modules/" >> "$DIR/.gitignore"
    echo "*.log" >> "$DIR/.gitignore"
    npm install
    npx prettier --write ./*
    update-package-versions
fi

neovim src/index.ts && exit 0
