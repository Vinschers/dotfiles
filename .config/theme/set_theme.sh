#!/bin/sh

get_theme() {
	theme="$(cat "$HOME/.config/theme/current" 2>/dev/null)"

	if [ -z "$theme" ]; then
		theme="$(/bin/ls "$HOME/.config/theme/themes/" | head -1)"
	elif [ -n "$1" ]; then
		if [ "$1" = "select" ]; then
			selected_theme="$(ls -1 "$HOME/.config/theme/themes" | wofi --show dmenu)"
			[ "$selected_theme" = "$theme" ] && exit 0
			[ -n "$selected_theme" ] && theme="$selected_theme"
		elif [ "$1" = "n" ]; then
			theme="$(/bin/ls -1 "$HOME/.config/theme/themes" | grep -A1 "$theme" | grep -v "$theme")"
			[ -z "$theme" ] && theme="$(/bin/ls -1 "$HOME/.config/theme/themes" | head -1)"
		elif [ "$1" = "p" ]; then
			theme="$(/bin/ls -1 "$HOME/.config/theme/themes" | grep -B1 "$theme" | grep -v "$theme")"
			[ -z "$theme" ] && theme="$(/bin/ls -1 "$HOME/.config/theme/themes" | tail -1)"
		fi
	fi

	echo "$theme" >"$HOME/.config/theme/current"
}

create_symlink() {
	ln -fs "$1" "$2"
}

create_config_symlinks() {
	create_symlink "/usr/share/btop/themes/$btop_theme.theme" "$HOME/.config/btop/themes/btop.theme"
}

read_variable() {
	variable="$1"
	json_file="$HOME/.config/theme/themes/$theme/theme.json"

	jq -r ".$variable" "$json_file"
}

read_variables() {
	gtk_theme="$(read_variable "gtk_theme")"
	gtk_icon="$(read_variable "gtk_icon")"
	gtk_cursor="$(read_variable "gtk_cursor")"

	btop_theme="$(read_variable "btop_theme")"

	nvim_theme="$(read_variable "nvim_theme")"
}

replace_file() {
	template="$1"
	file="$2"

	perl -pe "s(\\$\\{(.*)\\})(\`jq -r '.\$1' '$HOME/.config/theme/themes/$theme/theme.json' | sed 's|#||g' | tr -d '\n'\`)ge" <"$template" >"$file"
}

load_files() {
	replace_file "$HOME/.config/shell/change_theme.template.sh" "$HOME/.config/shell/change_theme.sh"
	replace_file "$HOME/.config/foot/theme.template.conf" "$HOME/.config/foot/theme.conf"
	replace_file "$HOME/.config/nvim/lua/utils/colorscheme.template.lua" "$HOME/.config/nvim/lua/utils/colorscheme.lua"
	replace_file "$HOME/.config/waybar/style/theme.template.css" "$HOME/.config/waybar/style/theme.css"
	replace_file "$HOME/.config/eww/css/_colors.template.scss" "$HOME/.config/eww/css/_colors.scss"
	replace_file "$HOME/.config/alacritty/theme.template.yml" "$HOME/.config/alacritty/theme.yml"
	replace_file "$HOME/.config/cava/config.template" "$HOME/.config/cava/config"

	chmod +x "$HOME/.config/shell/change_theme.sh"
}

reload_all() {
	"$HOME/.config/theme/update_wallpaper.sh"
	sleep 0.5

	ss -a | grep nvim | awk '{print $5}' | while read -r nvim_socket; do
		nvim --server "$nvim_socket" --remote-send ":colorscheme $nvim_theme<cr>"
	done

	killall -s USR1 zsh 2>/dev/null

	pkill -USR2 waybar 2>/dev/null

	killall -s USR1 cava 2>/dev/null

	gsettings set org.gnome.desktop.interface gtk-theme "$gtk_theme"
	gsettings set org.gnome.desktop.interface icon-theme "$gtk_icon"
	gsettings set org.gnome.desktop.interface cursor-theme "$gtk_cursor"
}

main() {
	get_theme "$1"

	read_variables

	load_files

	create_config_symlinks

	reload_all
}

main "$@"
