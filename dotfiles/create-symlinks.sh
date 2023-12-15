#!/bin/bash

# this script will not overwrite pre existing symlinks or normal files/dirs
# manually remove the config directories/files you want to symlink to

dotfiles_dir="$HOME/environment/dotfiles"

function print_success_message() {
    if [ "${1}" -eq 0 ]; then
        echo "Successfully created symlink for ${2}"
    fi
}

# takes 1 argument: name of directory
function link_dir_to_XDG_CONFIG_HOME() {
    path="$HOME/.config"
    if [ -d "${path}/${1}" ] || [ -L "${path}/${1}" ]; then
        echo "symlink not created - directory already exists in ${path}/${1}"
    else
        ln -s "${dotfiles_dir}/${1}" ~/.config/${1}
        print_success_message "${?}" "${1}"
    fi

}

# takes 2 arguments: name of directory, name of file
function link_file_to_HOME() {
    if [ -f "$HOME/${2}" ] || [ -L "$HOME/${2}" ]; then
        echo "symlink not created - file already exists in $HOME/${2}";
    else
        ln -s ${dotfiles_dir}/${1}/${2} ~/${2}
        print_success_message "${?}" "${2}"
    fi
}

# directories in ~/.config
link_dir_to_XDG_CONFIG_HOME "alacritty"
link_dir_to_XDG_CONFIG_HOME "nvim"
link_dir_to_XDG_CONFIG_HOME "ncmpcpp"
link_dir_to_XDG_CONFIG_HOME "mpd"
link_dir_to_XDG_CONFIG_HOME "mpv"
link_dir_to_XDG_CONFIG_HOME "tmux"

# files in ~/
link_file_to_HOME "bash" ".bashrc"
link_file_to_HOME "zsh" ".zshrc"
