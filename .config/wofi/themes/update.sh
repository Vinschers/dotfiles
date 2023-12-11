#!/bin/sh

update_theme() {
    ln -sf "$HOME/.config/wofi/themes/$1.css" "$HOME"/.config/wofi/style.css
}

if [ -n "$1" ]; then
    [ "$1" -eq 1 ] && update_theme "tokyonight"
fi
