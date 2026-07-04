#!/usr/bin/env bash

sudo cp applog.sh /usr/local/bin/applog

flatpak \
    remote-add \
    --if-not-exists \
    flathub \
    https://flathub.org/repo/flathub.flatpakrepo
