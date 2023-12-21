#!/bin/sh

update_theme() {
    sed -i "$HOME/.config/Kvantum/kvantum.kvconfig" -e "s/theme=.*/theme=$1/g"
}

if [ -n "$1" ]; then
    [ "$1" -eq 1 ] && update_theme "KvArcTokyoNight"
fi
