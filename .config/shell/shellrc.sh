#!/bin/sh

eval "$(dircolors -b "$HOME/.config/shell/.dir_colors")"

for script in "$HOME"/.config/shell/environment/*.sh; do
    . "$script"
done

for script in "$HOME"/.config/shell/functions/*.sh; do
    . "$script"
done

. "$HOME/.config/shell/aliases.sh"

if ! env | grep -q '^NVIM='; then
    neofetch
fi
