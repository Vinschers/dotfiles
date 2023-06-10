#!/bin/sh

themes_dir="$HOME/.config/themes"
wallpaper_name="$(cat "$themes_dir/wallpaper")"
[ -z "$wallpaper_name" ] && wallpaper_name="$(/bin/ls -1 "$themes_dir/wallpapers" | head -1)"

if [ "$1" = "n" ]; then
	next_wallpaper="$(/usr/bin/ls -1 "$themes_dir/wallpapers" | grep -A1 "$wallpaper_name" | grep -v "$wallpaper_name")"
	[ -z "$next_wallpaper" ] && next_wallpaper="$(/usr/bin/ls -1 "$themes_dir/wallpapers" | head -1)"

    effect="grow"
    bezier="0.33,0,1,0.4"
elif [ "$1" = "p" ]; then
	next_wallpaper="$(/usr/bin/ls -1 "$themes_dir/wallpapers" | grep -B1 "$wallpaper_name" | grep -v "$wallpaper_name")"
	[ -z "$next_wallpaper" ] && next_wallpaper="$(/usr/bin/ls -1 "$themes_dir/wallpapers" | tail -1)"

    effect="outer"
    bezier="0,0.33,0.4,1"
else
    next_wallpaper="$wallpaper_name"

    effect="grow"
    bezier="0.33,0,1,0.4"
fi

echo "$next_wallpaper" >"$themes_dir/wallpaper"

swww img "$themes_dir/wallpapers/$next_wallpaper" --transition-bezier "$bezier" --transition-type "$effect" --transition-duration 1 --transition-fps 60 --transition-pos 0.917,0.968
