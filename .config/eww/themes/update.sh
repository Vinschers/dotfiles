#!/bin/sh

update_theme() {
    ln -sf "$HOME/.config/eww/themes/$1.scss" "$HOME"/.config/eww/css/_colors.scss
}

if [ -n "$1" ]; then
    [ "$1" -eq 1 ] && update_theme "tokyonight"
fi

eww reload >/dev/null
