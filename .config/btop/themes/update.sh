#!/bin/sh

update_theme() {
    ln -sf "$HOME/.config/btop/themes/$1.theme" "$HOME"/.config/btop/themes/btop.theme
}

if [ -n "$1" ]; then
    [ "$1" -eq 1 ] && update_theme "tokyonight"
fi
