#!/bin/sh

update_theme() {
    if [ -f "$HOME/.config/Kvantum/kvantum.kvconfig" ]; then
        sed -i "$HOME/.config/Kvantum/kvantum.kvconfig" -e "s/theme=.*/theme=$1/g"
    else
        printf "[General]\ntheme=%s\n" "$1" > "$HOME/.config/Kvantum/kvantum.kvconfig"
    fi
}

if [ -n "$1" ]; then
    [ "$1" -eq 1 ] && update_theme "KvArcTokyoNight"
fi
