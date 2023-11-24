#!/bin/bash

# .bashrc
if [ ! -f "$HOME/.bashrc" ]; then
    ln -s ~/environment/dotfiles/bash/.bashrc ~/.bashrc
fi

# alacritty
if [ ! -d "$HOME/alacritty" ]; then
    ln -s ~/environment/dotfiles/alacritty ~/.config/alacritty
fi

# nvim
if [ ! -d "$HOME/.config/nvim" ]; then
    ln -s ~/environment/dotfiles/nvim ~/.config/nvim
fi
