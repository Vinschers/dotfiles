#!/bin/sh

update_theme() {
    ln -sf "./$1.conf" theme.conf
}

if [ -n "$1" ]; then
    [ "$1" -eq 1 ] && update_theme "tokyonight"
fi

hyprctl reload
