#!/bin/sh

wallpaper="$(jq -r '.wallpaper' <"$HOME/.config/theme/theme.json" | sed "s|~|$HOME|g")"

D=$(convert "$wallpaper" -format "%[fx:w<h?w:h]" info:)
convert "$wallpaper" -gravity center -crop "${D}x${D}+0+0" +repage "$HOME/.config/fastfetch/wallpaper" &
rm -rf "$HOME/.cache/fastfetch"

if ! pgrep swww; then
    swww init
    sleep 1
fi

swww img "$wallpaper" \
	--transition-bezier .5,.4,.5,1 \
	--transition-type grow \
	--transition-duration 1 \
	--transition-fps 75 &
