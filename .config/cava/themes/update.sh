#!/bin/sh

update_theme() {
    ln -sf "$HOME/.config/cava/themes/$1" "$HOME"/.config/cava/config
}

if [ -n "$1" ]; then
    [ "$1" -eq 1 ] && update_theme "tokyonight"
fi

killall -s USR1 cava 2>/dev/null
