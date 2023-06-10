#!/bin/sh

themes_dir="$HOME/.config/themes"
wallpaper_name="$(cat "$themes_dir/wallpaper")"

if [ -z "$1" ] || [ "$1" = "n" ]; then
	next_wallpaper="$(/usr/bin/ls -1 "$themes_dir/wallpapers" | grep -A1 "$wallpaper_name" | grep -v "$wallpaper_name")"
	[ -z "$next_wallpaper" ] && next_wallpaper="$(/usr/bin/ls -1 "$themes_dir/wallpapers" | head -1)"
elif [ "$1" = "p" ]; then
	next_wallpaper="$(/usr/bin/ls -1 "$themes_dir/wallpapers" | grep -B1 "$wallpaper_name" | grep -v "$wallpaper_name")"
	[ -z "$next_wallpaper" ] && next_wallpaper="$(/usr/bin/ls -1 "$themes_dir/wallpapers" | tail -1)"
else
    exit 1
fi

echo "$next_wallpaper" >"$themes_dir/wallpaper"

swww img "$themes_dir/wallpapers/$next_wallpaper" --transition-bezier .43,1.19,1,.4 --transition-type grow --transition-duration 1 --transition-fps 60 --transition-pos 0.917,0.968
