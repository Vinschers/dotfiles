#!/bin/sh

theme="$(cat "$HOME/.config/theme/current" 2>/dev/null)"
startup=1

THEMES_DIR="$HOME/.config/theme/themes"

if [ -z "$theme" ]; then
	if [ -z "$(ls -A "$THEMES_DIR")" ]; then
        theme=0
	else
        theme=1
	fi
elif [ -n "$1" ]; then
    n_themes=$(find "$THEMES_DIR" -mindepth 1 -maxdepth 1 -type d | wc -l)

	if [ "$1" = "n" ]; then
        theme=$(( 1 + (theme + 1) % n_themes ))
	elif [ "$1" = "p" ]; then
        theme=$((theme - 1))
        [ $theme -lt 1 ] && theme=$n_themes
	fi

	startup=0
fi

echo "$theme" >"$HOME/.config/theme/current"

"$HOME/.config/theme/set_theme.sh" $startup
