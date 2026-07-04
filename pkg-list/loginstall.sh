#!/usr/bin/env bash

# Flags:
# --apt, --flatpak, etc... logs app to the log file and alphabetizes the file
#
# --install=[apt|flatpak|etc...]  runs the install command for the file

print_help() {
    cat <<EOF
Usage:
    ./log-app.sh [ACTION] [PKGMAN]
EOF
}

styled_fzf() {
    fzf --style=full --layout=reverse
}

list_apt() {
    apt list --installed | cut -d '/' -f 1 | grep -v 'Listing...'
}

list_pipx() {
    pipx list --short | cut -d " " -f 1
}

list_npm() {
    npm list -g --json | jq -r '.dependencies | keys[]'
}

list_cargo() {
    cargo install --list | awk -F ' ' '{print $1}' | uniq
}

list_flatpak() {
    flatpak list --app --columns=application
}

list_nix() {
    nix profile list --json | jq -r '.elements | keys[]'
}

install_apt() {
    sudo apt install "${1}"
}

install_npm() {
    sudo npm install -g "${1}"
}

install_pipx() {
    echo "LOL IDK HOW TO INSTALL WITH PIPX BRO"
}

install_cargo() {
    cargo install "${1}"
}

install_flatpak() {
    flatpak install "${1}"
}

append() {
    local pkg="$(list_${pkgman} | styled_fzf)"

    echo "${pkg}" >> "${file}"
    cat "${file}" | uniq | sort --output="${file}"
}

install_from_pkg_man() {
    while IFS= read -r pkg; do
        "install_${pkgman}" "${pkg}"
    done< "${file}"
}

main() {
    local action="${1}"
    local pkgman="${2}"
    local file="$HOME/common/pkg-list/logs/${pkgman}.log"

    if [[ ! -f $file ]]; then print_help && exit 0; fi

    [[ $action == "--help" ]] && print_help && exit 0
    [[ $action == "append" ]] && append
    [[ $action == "install" ]] && install_from_pkg_man
    [[ $action == "list" ]] && batcat "${file}"
}

main "${@}"
