#!/bin/sh

create_config_symlinks() {
	ln -fs "/usr/share/btop/themes/$btop_theme.theme" "$HOME/.config/btop/themes/btop.theme"
	for file in "$HOME/.config/spicetify/Themes/$spicetify_theme"/*; do
		ln -fs "$file" "$HOME/.config/spicetify/Themes/default"
	done

	for file in "$HOME/.config/spicetify/Themes/default"/*; do
		[ -e "$HOME/.config/spicetify/Themes/$spicetify_theme/$(basename "$file")" ] || rm -rf "$file"
	done

	spicetify config color_scheme "$spicetify_color_scheme" -q

    [ -d "$HOME/.config/spicetify/Backup" ] || spicetify backup -q
}

read_variable() {
	variable="$1"
	json_file="$HOME/.config/theme/themes/$theme/theme.json"

	jaq -r ".$variable" "$json_file"
}

read_variables() {
	gtk_theme="$(read_variable "gtk_theme")"
	gtk_icon="$(read_variable "gtk_icon")"
	gtk_cursor="$(read_variable "gtk_cursor")"

	btop_theme="$(read_variable "btop_theme")"

	nvim_theme="$(read_variable "nvim_theme")"

	spicetify_theme="$(read_variable "spicetify_theme")"
	spicetify_color_scheme="$(read_variable "spicetify_color_scheme")"
}

replace_file() {
	template="$1"
	file="$2"

	perl -pe "s(\\$\\{(.*)\\})(\`jaq -r '.\$1' '$HOME/.config/theme/themes/$theme/theme.json' | sed 's|#||g' | tr -d '\n'\`)ge" <"$template" >"$file"
}

load_files() {
	replace_file "$HOME/.config/shell/change_theme.template.sh" "$HOME/.config/shell/change_theme.sh"
	replace_file "$HOME/.config/foot/theme.template.conf" "$HOME/.config/foot/theme.conf"
	replace_file "$HOME/.config/nvim/lua/utils/colorscheme.template.lua" "$HOME/.config/nvim/lua/utils/colorscheme.lua"
	replace_file "$HOME/.config/waybar/style/theme.template.css" "$HOME/.config/waybar/style/theme.css"
	replace_file "$HOME/.config/eww/css/_colors.template.scss" "$HOME/.config/eww/css/_colors.scss"
	replace_file "$HOME/.config/alacritty/theme.template.yml" "$HOME/.config/alacritty/theme.yml"
	replace_file "$HOME/.config/cava/config.template" "$HOME/.config/cava/config"
	replace_file "$HOME/.config/bat/config.template" "$HOME/.config/bat/config"
	replace_file "$HOME/.config/zathura/zathurarc.template" "$HOME/.config/zathura/zathurarc"
	replace_file "$HOME/.config/wofi/style.template.css" "$HOME/.config/wofi/style.css"
	replace_file "$HOME/.config/wlogout/style.template.css" "$HOME/.config/wlogout/style.css"
	replace_file "$HOME/.config/dunst/dunstrc.template" "$HOME/.config/dunst/dunstrc"

	chmod +x "$HOME/.config/shell/change_theme.sh"

	sed -i "$HOME/.local/share/nwg-look/gsettings" \
		-e "s/gtk-theme=.*/gtk-theme=$gtk_theme/g" \
		-e "s/icon-theme=.*/icon-theme=$gtk_icon/g" \
		-e "s/cursor-theme=.*/cursor-theme=$gtk_cursor/g"

	sed -i "$HOME/.config/gtk-2.0/gtkrc" \
		-e "s/gtk-theme-name=.*/gtk-theme-name=\"$gtk_theme\"/g" \
		-e "s/gtk-icon-theme-name=.*/gtk-icon-theme-name=\"$gtk_icon\"/g" \
		-e "s/gtk-cursor-theme-name=.*/gtk-cursor-theme-name=\"$gtk_cursor\"/g"

	sed -i "$HOME/.config/gtk-3.0/settings.ini" \
		-e "s/gtk-theme-name=.*/gtk-theme-name=\"$gtk_theme\"/g" \
		-e "s/gtk-icon-theme-name=.*/gtk-icon-theme-name=\"$gtk_icon\"/g" \
		-e "s/gtk-cursor-theme-name=.*/gtk-cursor-theme-name=\"$gtk_cursor\"/g"
}

reload_all() {
	"$HOME/.config/theme/update_wallpaper.sh"

	killall -s USR1 zsh 2>/dev/null
	killall -s USR1 cava 2>/dev/null
	pkill dunst && hyprctl dispatch exec dunst >/dev/null

	ss -a | grep nvim | awk '{print $5}' | while read -r nvim_socket; do
		nvim --server "$nvim_socket" --remote-send ":colorscheme $nvim_theme<cr>"
	done

	nwg-look -a >/dev/null 2>/dev/null

	if pgrep spotify >/dev/null; then
		spicetify -s watch &
		sleep 1 && pkill spicetify
	fi

	pkill -USR2 waybar 2>/dev/null
	pgrep waybar >/dev/null || hyprctl dispatch exec waybar >/dev/null
}

main() {
	theme="$(cat "$HOME/.config/theme/current" 2>/dev/null)"

	read_variables

	load_files

	create_config_symlinks

	reload_all
}

main
