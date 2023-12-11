#!/bin/sh

update_theme() {
    ln -sf "$HOME/.config/zathura/themes/$1" "$HOME"/.config/zathura/theme
}

if [ -n "$1" ]; then
    [ "$1" -eq 1 ] && update_theme "tokyonight"
fi
