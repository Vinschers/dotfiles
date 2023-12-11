#!/bin/sh

update_theme() {
    ln -sf "$HOME/.config/dunst/themes/$1" "$HOME"/.config/dunst/theme
}

if [ -n "$1" ]; then
    [ "$1" -eq 1 ] && update_theme "tokyonight"
fi

hyprctl dispatch exec "cat $HOME/.config/dunst/dunstrc $HOME/.config/dunst/theme | dunst -conf -" >/dev/null
