#!/bin/sh

themes_dir="$HOME/.config/themes"
theme="$(cat "$themes_dir/theme")"

rm "$themes_dir/current"
ln -s "$themes_dir/$theme" "$themes_dir/current"

killall -SIGUSR2 waybar
