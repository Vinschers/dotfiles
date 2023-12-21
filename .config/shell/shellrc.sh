#!/bin/sh

eval "$(dircolors -b "$HOME/.config/shell/.dir_colors")"

for script in "$HOME"/.config/shell/environment/*.sh; do
	. "$script"
done

for script in "$HOME"/.config/shell/functions/*.sh; do
	. "$script"
done

. "$HOME/.config/shell/aliases.sh"

if ! env | grep -q '^NVIM=' && [ -z "$SHLVL" ] || [ $SHLVL -lt 2 ]; then
    fastfetch
fi
