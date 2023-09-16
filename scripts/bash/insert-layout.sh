#!/bin/bash

function printTemplates() {
    echo ""
    echo "[OPTIONS]"
    echo "1: holy-grail: header, sidebar, main-content"
    echo "2: modal-sidebar: header, main-content with sidebar modal"
    echo "3: simple app: fixed header and footer with main content"
    echo ""
}

function chooseLayout() {
    templateDir="$HOME/environment/resources/templates/layouts"
    case $1 in
        "1")
            template="$templateDir/holy-grail"
            buildLayout "$template";;
        "2") 
            template="$templateDir/modal-sidebar"
            buildLayout "$template";;
        "3") 
            template="$templateDir/simple-app"
            buildLayout "$template";;
        *) echo "unknown template number" && exit 1
    esac
}

function buildLayout() {
    html="$1/dist/index.html"
    src="$1/src"
    dest=$(pwd)
    cp "$html" "$dest/dist/index.html" || exit 1
    cp -r "$src/"* "$dest/src/" || exit 1
}

echo -e "\033[33m[WARNING]\033[0m running this script will erase all work in the current project"
echo -e "\033[33m[WARNING]\033[0m only use this script in conjuction with TypeScript and SASS"
echo -n "Type 'YES' to proceed: "
read answer

if [ "$answer" = 'yes' ] || [ "$answer" = 'Yes' ]; then 
    printTemplates
    echo -n "Enter the number of the layout to copy: "
    read answer
    chooseLayout "$answer" || exit 1
    printf "\nLayout created successfully\n"           
fi





