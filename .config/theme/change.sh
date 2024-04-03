#!/bin/sh

update_theme() {
	themes_directory="$HOME/.config/theme/themes"
	themes="$(/bin/ls "$themes_directory" -1)"

	if ! [ -f "$HOME/.config/theme/theme.json" ]; then
		first_theme="$(echo "$themes" | head -1)"
		echo "$themes_directory/$first_theme"
		return
	fi

	theme="$(basename "$(readlink -f "$HOME/.config/theme/theme.json")")"
	theme_num="$(echo "$themes" | grep -n "$theme" | cut -d: -f1)"

	total="$(echo "$themes" | wc -l)"

	if [ "$1" = "-1" ]; then
		theme_num=$((theme_num - 1))
		[ "$theme_num" -eq 0 ] && theme_num="$total"
	elif [ "$1" = "1" ]; then
		theme_num=$((theme_num + 1))
		[ "$theme_num" -gt "$total" ] && theme_num="1"
	fi

	new_theme="$(echo "$themes" | sed -n "${theme_num}p")"
	[ -z "$new_theme" ] && new_theme="$(echo "$themes" | head -1)"

	echo "$themes_directory/$new_theme"
}

new_theme="$(update_theme "$1")"

if [ -f "$HOME/.config/theme/theme.json" ]; then
	cp "$HOME/.config/theme/theme.json" "$HOME/.cache/old_theme.json"
else
	echo "{}" >"$HOME/.cache/old_theme.json"
fi

ln -sf "$new_theme" "$HOME/.config/theme/theme.json"

python "$HOME/.config/theme/utils/update.py"

[ -z "$1" ] && swww-daemon
