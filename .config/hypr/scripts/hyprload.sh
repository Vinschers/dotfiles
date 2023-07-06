#!/bin/sh

if ! [ -d "$HOME/.local/share/hyprload" ]; then
    curl -sSL https://raw.githubusercontent.com/Duckonaut/hyprload/main/install.sh | bash
    . "$HOME/.local/share/hyprload/hyprload.sh"
    hyprctl dispatch hyprload update
fi
