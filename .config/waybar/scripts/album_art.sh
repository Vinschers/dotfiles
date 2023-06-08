#!/bin/sh

pgrep spotify >/dev/null || exit
url="$(playerctl -p spotify metadata -f '{{mpris:artUrl}}')"

[ -z "$url" ] && exit

path="$HOME/.cache/music_covers"
filename="$(basename "$url")"

mkdir -p "$path"

if ! [ -e "$path/$filename" ]; then
	/bin/rm -f "$path"/*
	curl -so "$path/$filename.png" "$url"
    convert -size 600x600 xc:none -fill "$path/$filename.png" -draw "circle 300,300 300,1" "$path/cover.png"
fi

echo "$path/cover.png"
