#!/bin/bash

function link_dir_to_XDG_CONFIG_HOME() {
    path="$HOME/.config"
    if [ ! -d "${path}/${1}" ]; then
        if [ ! -L "${path}/${1}" ]; then
            ln -s ~/environment/dotfiles/${1} ~/.config/${1}
        fi
    fi
}

function link_file_to_HOME() {
    if [ ! -f "$HOME/${2}" ]; then
        if [ ! -L "$HOME/${2}" ]; then
            ln -s ~/environment/dotfiles/${1}/${2} ~/${2}
        fi
    fi
}

# directories in ~/.config
link_dir_to_XDG_CONFIG_HOME "alacritty"
link_dir_to_XDG_CONFIG_HOME "nvim"
link_dir_to_XDG_CONFIG_HOME "ncmpcpp"
link_dir_to_XDG_CONFIG_HOME "mpd"
link_dir_to_XDG_CONFIG_HOME "mpv"

# files in ~/
link_file_to_HOME "bash" ".bashrc"
