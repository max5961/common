#!/bin/bash

cwd=$(pwd)
templateDir="/home/max/common/scripts/setup/setup-express"
template="$templateDir/template/."

read -rp "React? [y/n]: " answer

if [[ "$answer" == "" || "$answer" == "y" || "$answer" == "Y" ]]; then
    echo "Setting up react...";
    template="$templateDir/react-template/."
else
    echo "Setting up without react..."
fi


cp -r "$template" "$cwd"
npm install
git init
