#!/bin/bash

function installNodeModules() {
    npm init -y

    # webpack
    npm install --save-dev webpack webpack-cli
    # browser sync
    npm install --save-dev browser-sync-webpack-plugin
    # css
    npm install --save-dev style-loader css-loader
    # sass
    npm install --save-dev sass-loader sass
    # typescript
    npm install --save-dev typescript ts-loader
    npm install --save-dev @typescript-eslint/eslint-plugin@latest
    # eslint
    npm install --save-dev eslint eslint-config-prettier
    # prettier
    npm install --save-dev --save-exact prettier
    # stylelint
    npm install --save-dev stylelint stylelint-scss
    # babel
    npm install --save-dev babel-loader @babel/core @babel/preset-env
    # data
    # npm install --save-dev csv-loader xml-loader

    # react specific
    npm install react react-dom
    # typescript
    npm install --save-dev @types/react @types/react-dom
    # babel
    npm install --save-dev @babel/preset-react @babel/preset-typescript
    # eslint
    npm install --save-dev eslint-plugin-react eslint-plugin-react-hooks

}

function copyFiles() {
    echo "Creating files..."
    cwd="$(pwd)"

    # copy main file structure
    source_dir="$HOME/common/scripts/webpack/setup/react/file-structure/"
    cp -r "$source_dir". "$cwd"

    # copy css reset
    css_reset="$HOME/common/templates/css-resets/reset.css"
    cat "$css_reset" >"$cwd"/src/style/reset.css

    # copy .prettierrc.json
    prettier_config="$HOME/common/templates/dotfiles/.prettierrc.json"
    cp "$prettier_config" "$cwd"/.prettierrc.json

    # copy .stylelintrc.json
    stylelintConfig="$HOME/common/templates/dotfiles/.stylelintrc.json"
    cp "$stylelintConfig" "$cwd/.stylelintrc.json"

    if [ "$?" -eq 0 ]; then
        echo "Successfully created files"
    fi
}

function initializeGitRepository() {
    read -rp "Initialize empty git repository? [y/n]: " answer
    if [ "$answer" = "y" ] || [ "$answer" == "Y"] || [ "$answer" == "" ]; then
        git init
        echo /node_modules >>.gitignore
        git add *
        git commit -m "Initial commit. Setup webpack"
        git branch -M main
        if [ $? -eq 0 ]; then
            echo -e "\033[32mGit initialized in $(pwd)\033[0m"
        fi
    fi
}

installNodeModules
copyFiles
initializeGitRepository
