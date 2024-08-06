#!/bin/bash

sudo apt update

echo -e "\n[UPGRADABLE PACKAGES]\n"
apt list --upgradeable

echo "" && read -rp "Upgrade? [y/n]: " answer

if [[ $answer == "" || $answer == "y" || $answer == "Y" ]]; then
    sudo apt upgrade
fi
