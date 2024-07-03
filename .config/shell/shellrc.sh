#!/bin/sh

eval "$(dircolors -b "$HOME/.config/shell/.dir_colors")"

# shellcheck disable=1009
for script in "$HOME"/.config/shell/environment/*.sh; do
	# shellcheck disable=1090
	. "$script"
done

for script in "$HOME"/.config/shell/functions/*.sh; do
	# shellcheck disable=1090
	. "$script"
done

# shellcheck disable=1091
. "$HOME/.config/shell/aliases.sh"

if ! env | grep -q '^NVIM=' && [ -z "$SHLVL" ] || [ $SHLVL -lt 2 ]; then
	fastfetch
fi
