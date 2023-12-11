#!/bin/sh

update_theme() {
    ln -sf "$HOME/.config/shell/themes/$1.sh" "$HOME"/.config/shell/theme.sh
}

if [ -n "$1" ]; then
    [ "$1" -eq 1 ] && update_theme "tokyonight"
fi

killall -s USR1 zsh 2>/dev/null
