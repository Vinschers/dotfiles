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
	else
		theme_num=$((theme_num + 1))
		[ "$theme_num" -gt "$total" ] && theme_num="1"
	fi

	new_theme="$(echo "$themes" | sed -n "${theme_num}p")"
    [ -z "$new_theme" ] && new_theme="$(echo "$themes" | head -1)"

    echo "$themes_directory/$new_theme"
}

new_theme="$(update_theme "$1")"
ln -sf "$new_theme" "$HOME/.config/theme/theme.json"

wallpaper="$(jq -r '.wallpaper' < "$HOME/.config/theme/theme.json" | sed "s|~|$HOME|g")"

D=$(convert "$wallpaper" -format "%[fx:w<h?w:h]" info:)
convert "$wallpaper" -gravity center -crop "${D}x${D}+0+0" +repage "$HOME/.config/fastfetch/wallpaper" &
rm -rf "$HOME/.cache/fastfetch"

swww img "$wallpaper" \
	--transition-bezier .5,.4,.5,1 \
	--transition-type grow \
	--transition-duration 1 \
	--transition-fps 75 &

python "$HOME/.config/theme/update.py"
