#!/bin/sh

update_theme() {
	"$HOME"/.config/"$1"/themes/update.sh "$2"
}

startup="$1"
theme="$(cat "$HOME/.config/theme/current" 2>/dev/null)"

if [ -n "$startup" ] && [ "$startup" -eq 0 ]; then
	"$HOME"/.local/share/wallpapers/update.sh "$theme"

	notify-send "$theme"
fi

update_theme "hypr" "$theme"
update_theme "cava" "$theme"
update_theme "shell" "$theme"
update_theme "dunst" "$theme"
update_theme "eww" "$theme"
update_theme "foot" "$theme"
update_theme "nvim" "$theme"
update_theme "wlogout" "$theme"
update_theme "wofi" "$theme"
update_theme "zathura" "$theme"
update_theme "btop" "$theme"
update_theme "spicetify" "$theme"
update_theme "Kvantum" "$theme"
"$HOME"/.config/theme/set_gtk.sh "$theme"
