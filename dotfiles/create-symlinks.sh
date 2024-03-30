#!/bin/bash

# This script will not overwrite pre-existing symlinks or normal files/dirs.
# Manually move the config directories or files to a folder in the $dotfiles_dir
# and this script will symlink them to either $HOME/.config or $HOME

dotfiles_dir="$HOME/common/dotfiles"

function print_success_message() {
    if [ "$1" -eq 0 ]; then
        echo "Successfully created symlink for $2"
    fi
}

# accepts 1 argument: name of directory
function link_dir_to_XDG_CONFIG_HOME() {
    path="$HOME/.config"
    if [ -d "$path/$1" ] || [ -L "$path/$1" ]; then
        echo "symlink not created - directory already exists in ${path}/${1}"
    else
        ln -s "$dotfiles_dir/$1" "$HOME/.config/$1"
        print_success_message "$?" "$1"
    fi

}

# accepts 2 arguments: name of directory, name of file
function link_file_to_HOME() {
    if [ -f "$HOME/$2" ] || [ -L "$HOME/$2" ]; then
        echo "symlink not created - file already exists in $HOME/$2"
    else
        ln -s "$dotfiles_dir/$1/$2 $HOME/$2"
        print_success_message "$?" "$2"
    fi
}

# directories in ~/.config
link_dir_to_XDG_CONFIG_HOME "alacritty"
link_dir_to_XDG_CONFIG_HOME "nvim"
link_dir_to_XDG_CONFIG_HOME "ncmpcpp"
link_dir_to_XDG_CONFIG_HOME "mpd"
link_dir_to_XDG_CONFIG_HOME "mpv"
link_dir_to_XDG_CONFIG_HOME "tmux"
link_dir_to_XDG_CONFIG_HOME "i3"
link_dir_to_XDG_CONFIG_HOME "lf"
link_dir_to_XDG_CONFIG_HOME "rofi"
link_dir_to_XDG_CONFIG_HOME "picom"
link_dir_to_XDG_CONFIG_HOME "polybar"

# files in ~/
link_file_to_HOME "bash" ".bashrc"
link_file_to_HOME "zsh" ".zshrc"
