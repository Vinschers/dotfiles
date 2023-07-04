#!/bin/sh

if ! [ -d "$HOME/.local/share/hyprload" ]; then
    curl -sSL https://raw.githubusercontent.com/Duckonaut/hyprload/main/install.sh | bash
    sleep 1
    hyprctl reload
    sleep 1
    hyprctl dispatch hyprload update
fi
