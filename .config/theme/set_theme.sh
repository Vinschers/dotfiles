#!/bin/sh

create_symlink() {
	ln -fs "$1" "$2"
}

create_config_symlinks() {
	create_symlink "/usr/share/btop/themes/$btop_theme.theme" "$HOME/.config/btop/themes/btop.theme"
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
	spicetify_extension="$(read_variable "spicetify_extension")"
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
}

reload_all() {
	"$HOME/.config/theme/update_wallpaper.sh"

	killall -s USR1 zsh 2>/dev/null
	killall -s USR1 cava 2>/dev/null
	killall dunst

	ss -a | grep nvim | awk '{print $5}' | while read -r nvim_socket; do
		nvim --server "$nvim_socket" --remote-send ":colorscheme $nvim_theme<cr>"
	done

	spicetify config current_theme "$spicetify_theme" color_scheme "$spicetify_color_scheme" -q

	spotify_ws="$(hyprctl -j workspaces | jaq -r '.[] | select(.lastwindowtitle=="Spotify") | .id')"
	spicetify apply -q
	if [ -n "$spotify_ws" ]; then
		sleep 2
		hyprctl dispatch exec "[workspace $spotify_ws silent] spotify" >/dev/null
		sleep 2
		playerctl -p spotify play
	fi

	gsettings set org.gnome.desktop.interface gtk-theme "$gtk_theme"
	gsettings set org.gnome.desktop.interface icon-theme "$gtk_icon"
	gsettings set org.gnome.desktop.interface cursor-theme "$gtk_cursor"

	pkill -USR2 waybar 2>/dev/null
    pgrep waybar || hyprctl dispatch exec waybar >/dev/null
}

main() {
	theme="$(cat "$HOME/.config/theme/current" 2>/dev/null)"

	read_variables

	load_files

	create_config_symlinks

	reload_all
}

main
