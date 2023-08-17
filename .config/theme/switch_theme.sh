#!/bin/sh


theme="$(cat "$HOME/.config/theme/current" 2>/dev/null)"
startup=1

if [ -z "$theme" ]; then
	theme="$(/bin/ls "$HOME/.config/theme/themes/" | head -1)"
elif [ -n "$1" ]; then
	if [ "$1" = "select" ]; then
		selected_theme="$(/bin/ls -1 "$HOME/.config/theme/themes" | wofi --show dmenu)"
		[ "$selected_theme" = "$theme" ] && exit 0
		[ -n "$selected_theme" ] && theme="$selected_theme"
	elif [ "$1" = "n" ]; then
		theme="$(/bin/ls -1 "$HOME/.config/theme/themes" | grep -A1 "$theme" | grep -v "$theme")"
		[ -z "$theme" ] && theme="$(/bin/ls -1 "$HOME/.config/theme/themes" | head -1)"
	elif [ "$1" = "p" ]; then
		theme="$(/bin/ls -1 "$HOME/.config/theme/themes" | grep -B1 "$theme" | grep -v "$theme")"
		[ -z "$theme" ] && theme="$(/bin/ls -1 "$HOME/.config/theme/themes" | tail -1)"
	fi

    startup=0
fi

echo "$theme" >"$HOME/.config/theme/current"

"$HOME/.config/theme/set_theme.sh" $startup
