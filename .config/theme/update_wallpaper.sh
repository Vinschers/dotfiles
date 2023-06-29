#!/bin/sh


theme="$(cat "$HOME/.config/theme/current" 2>/dev/null)"

if [ -z "$theme" ]; then
	theme="$(/bin/ls "$HOME/.config/theme/themes/" | head -1)"
	echo "$theme" >"$HOME/.config/theme/current"
fi

wallpaper_name="$(cat "$HOME/.config/theme/themes/$theme/wallpaper")"
[ -z "$wallpaper_name" ] && wallpaper_name="$(/bin/ls -1 "$HOME/.config/theme/themes/$theme/wallpapers" | head -1)"

if [ "$1" = "n" ]; then
	next_wallpaper="$(/bin/ls -1 "$HOME/.config/theme/themes/$theme/wallpapers" | grep -A1 "$wallpaper_name" | grep -v "$wallpaper_name")"
	[ -z "$next_wallpaper" ] && next_wallpaper="$(/bin/ls -1 "$HOME/.config/theme/themes/$theme/wallpapers" | head -1)"

    effect="grow"
    bezier="0.33,0,1,0.4"
elif [ "$1" = "p" ]; then
	next_wallpaper="$(/bin/ls -1 "$HOME/.config/theme/themes/$theme/wallpapers" | grep -B1 "$wallpaper_name" | grep -v "$wallpaper_name")"
	[ -z "$next_wallpaper" ] && next_wallpaper="$(/bin/ls -1 "$HOME/.config/theme/themes/$theme/wallpapers" | tail -1)"

    effect="outer"
    bezier="0,0.33,0.4,1"
else
    next_wallpaper="$wallpaper_name"

    effect="grow"
    bezier="0.33,0,1,0.4"
fi

echo "$next_wallpaper" >"$HOME/.config/theme/themes/$theme/wallpaper"

swww img "$HOME/.config/theme/themes/$theme/wallpapers/$next_wallpaper" --transition-bezier "$bezier" --transition-type "$effect" --transition-duration 1 --transition-fps 60 --transition-pos 0.917,0.968
