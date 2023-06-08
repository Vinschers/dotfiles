#!/bin/sh

cava -p "$HOME/.config/waybar/cava.conf" | while read -r line; do
    [ "$(playerctl -l 2>/dev/null | wc -l)" -eq 0 ] && exit
	echo "$line" | sed -u 's/;//g;s/0/▁/g;s/1/▂/g;s/2/▃/g;s/3/▄/g;s/4/▅/g;s/5/▆/g;s/6/▇/g;s/7/█/g;'
done
