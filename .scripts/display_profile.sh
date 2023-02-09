#!/bin/sh

# Script run when starting Xorg or Wayland

dunst &
wallpaper="$(ls "$HOME/.config" | grep wallpaper | head -n 1)"
chwall "$HOME/.config/$wallpaper"
#python "$SCRIPTS_DIR/external/inkscape-shortcut-manager/main.py" &
