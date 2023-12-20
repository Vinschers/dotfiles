#!/bin/sh

update_theme() {
    ln -sf "$HOME/.config/hypr/themes/$1.conf" "$HOME/.config/hypr/theme.conf"
}

if [ -n "$1" ]; then
    [ "$1" -eq 1 ] && update_theme "tokyonight"
fi

hyprctl reload
