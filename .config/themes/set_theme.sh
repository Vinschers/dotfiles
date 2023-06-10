#!/bin/sh

themes_dir="$HOME/.config/themes"
theme="$(cat "$themes_dir/theme")"
[ -z "$theme" ] && theme="$(/bin/ls -d */ | cut -f1 -d'/' | grep -Pv "wallpapers|current" | head -1)"

[ -d "$themes_dir/current" ] && rm "$themes_dir/current"
ln -s "$themes_dir/$theme" "$themes_dir/current"

ln -s "$themes_dir/current/nvim.lua" "$HOME/.config/nvim/lua/utils/colorscheme.lua"
ln -s "$themes_dir/current/waybar.css" "$HOME/.config/waybar/style/theme.css"
