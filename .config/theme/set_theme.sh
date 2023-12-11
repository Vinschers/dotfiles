#!/bin/sh

copy_gtk_files() {
	mkdir -p "$HOME/.local/share/themes"
	[ -d "$HOME/.local/share/themes/$theme" ] || cp -r "$HOME/.config/theme/themes/$theme/configs/gtk/theme" "$HOME/.local/share/themes/$theme"

	mkdir -p "$HOME/.local/share/icons"
	[ -d "$HOME/.local/share/icons/$theme" ] || cp -r "$HOME/.config/theme/themes/$theme/configs/gtk/icons" "$HOME/.local/share/icons/$theme"
}

update_gtk() {
	copy_gtk_files

	mkdir -p "$HOME/.local/share/nwg-look"
	sed -i "$HOME/.local/share/nwg-look/gsettings" \
		-e "s/gtk-theme=.*/gtk-theme=$theme/g" \
		-e "s/icon-theme=.*/icon-theme=$theme/g" \
		-e "s/cursor-theme=.*/cursor-theme=$theme/g"

	mkdir -p "$HOME/.config/gtk-2.0"
	sed -i "$HOME/.config/gtk-2.0/gtkrc" \
		-e "s/gtk-theme-name=.*/gtk-theme-name=\"$theme\"/g" \
		-e "s/gtk-icon-theme-name=.*/gtk-icon-theme-name=\"$theme\"/g" \
		-e "s/gtk-cursor-theme-name=.*/gtk-cursor-theme-name=\"$theme\"/g"

	mkdir -p "$HOME/.config/gtk-3.0"
	sed -i "$HOME/.config/gtk-3.0/settings.ini" \
		-e "s/gtk-theme-name=.*/gtk-theme-name=\"$theme\"/g" \
		-e "s/gtk-icon-theme-name=.*/gtk-icon-theme-name=\"$theme\"/g" \
		-e "s/gtk-cursor-theme-name=.*/gtk-cursor-theme-name=\"$theme\"/g"
}

update_theme() {
	"$HOME"/.config/"$1"/themes/update.sh "$2"
}

startup=$1
theme="$(cat "$HOME/.config/theme/current" 2>/dev/null)"

[ "$startup" -eq 0 ] && notify-send "$theme"

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
