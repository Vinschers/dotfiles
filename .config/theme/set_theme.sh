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

create_config_symlinks() {
	rm -f "$HOME/.config/nvim/lua/utils/colorscheme.lua"
	ln -s "$HOME/.config/theme/files/nvim.lua" "$HOME/.config/nvim/lua/utils/colorscheme.lua"

	rm -f "$HOME/.config/waybar/style/theme.css"
	ln -s "$HOME/.config/theme/files/waybar.css" "$HOME/.config/waybar/style/theme.css"

	rm -f "$HOME/.config/eww/css/_colors.scss"
	ln -s "$HOME/.config/theme/files/eww.scss" "$HOME/.config/eww/css/_colors.scss"

	rm -f "$HOME/.config/cava/config"
	ln -s "$HOME/.config/theme/files/cava.config" "$HOME/.config/cava/config"

	rm -f "$HOME/.config/btop/themes/btop.theme"
	ln -s "/usr/share/btop/themes/$btop_theme.theme" "$HOME/.config/btop/themes/btop.theme"
}

read_variable() {
	variable="$1"
	json_file="$HOME/.config/theme/themes/$theme/theme.json"

	jq -r ".$variable" "$json_file"
}

read_variables() {
	fg="$(read_variable "foreground" | sed 's|#||g')"
	bg="$(read_variable "background" | sed 's|#||g')"

	color0="$(read_variable "color0" | sed 's|#||g')"
	color1="$(read_variable "color1" | sed 's|#||g')"
	color2="$(read_variable "color2" | sed 's|#||g')"
	color3="$(read_variable "color3" | sed 's|#||g')"
	color4="$(read_variable "color4" | sed 's|#||g')"
	color5="$(read_variable "color5" | sed 's|#||g')"
	color6="$(read_variable "color6" | sed 's|#||g')"
	color7="$(read_variable "color7" | sed 's|#||g')"

	color8="$(read_variable "color8" | sed 's|#||g')"
	color9="$(read_variable "color9" | sed 's|#||g')"
	color10="$(read_variable "color10" | sed 's|#||g')"
	color11="$(read_variable "color11" | sed 's|#||g')"
	color12="$(read_variable "color12" | sed 's|#||g')"
	color13="$(read_variable "color13" | sed 's|#||g')"
	color14="$(read_variable "color14" | sed 's|#||g')"
	color15="$(read_variable "color15" | sed 's|#||g')"

	gtk_theme="$(read_variable "gtk_theme")"
	gtk_icon="$(read_variable "gtk_icon")"
	gtk_cursor="$(read_variable "gtk_cursor")"

    color_cava_1="$(read_variable "color_cava_1" | sed 's|#||g')"
    color_cava_2="$(read_variable "color_cava_2" | sed 's|#||g')"
    color_cava_3="$(read_variable "color_cava_3" | sed 's|#||g')"
    color_cava_4="$(read_variable "color_cava_4" | sed 's|#||g')"
    color_cava_5="$(read_variable "color_cava_5" | sed 's|#||g')"
    color_cava_6="$(read_variable "color_cava_6" | sed 's|#||g')"
    color_cava_7="$(read_variable "color_cava_7" | sed 's|#||g')"
    color_cava_8="$(read_variable "color_cava_8" | sed 's|#||g')"

    btop_theme="$(read_variable "btop_theme")"

	nvim_theme="$(read_variable "nvim_theme")"
}

replace_file() {
	file="$HOME/.config/theme/templates/$1"

	sed -e "s|\${fg}|$fg|g" \
		-e "s|\${bg}|$bg|g" \
		-e "s|\${color0}|$color0|g" \
		-e "s|\${color1}|$color1|g" \
		-e "s|\${color2}|$color2|g" \
		-e "s|\${color3}|$color3|g" \
		-e "s|\${color4}|$color4|g" \
		-e "s|\${color5}|$color5|g" \
		-e "s|\${color6}|$color6|g" \
		-e "s|\${color7}|$color7|g" \
		-e "s|\${color8}|$color8|g" \
		-e "s|\${color9}|$color9|g" \
		-e "s|\${color10}|$color10|g" \
		-e "s|\${color11}|$color11|g" \
		-e "s|\${color12}|$color12|g" \
		-e "s|\${color13}|$color13|g" \
		-e "s|\${color14}|$color14|g" \
		-e "s|\${color15}|$color15|g" \
		-e "s|\${color_cava_1}|$color_cava_1|g" \
		-e "s|\${color_cava_2}|$color_cava_2|g" \
		-e "s|\${color_cava_3}|$color_cava_3|g" \
		-e "s|\${color_cava_4}|$color_cava_4|g" \
		-e "s|\${color_cava_5}|$color_cava_5|g" \
		-e "s|\${color_cava_6}|$color_cava_6|g" \
		-e "s|\${color_cava_7}|$color_cava_7|g" \
		-e "s|\${color_cava_8}|$color_cava_8|g" \
		-e "s|\${nvim_theme}|$nvim_theme|g" "$file" >"$HOME/.config/theme/files/$1"
}

reload_all() {
	"$HOME/.config/theme/update_wallpaper.sh"
	sleep 0.5

	ss -a | grep nvim | awk '{print $5}' | while read -r nvim_socket; do
        nvim --server "$nvim_socket" --remote-send ":colorscheme $nvim_theme<cr>"
	done

	killall -s USR1 zsh 2>/dev/null

	pkill -USR2 waybar

    pkill -USR1 cava

    gsettings set org.gnome.desktop.interface gtk-theme "$gtk_theme"
    gsettings set org.gnome.desktop.interface icon-theme "$gtk_icon"
    gsettings set org.gnome.desktop.interface cursor-theme "$gtk_cursor"
}

main() {
	get_theme "$1"

	read_variables

	replace_file "shell.sh"
	replace_file "foot.conf"
	replace_file "nvim.lua"
	replace_file "waybar.css"
	replace_file "eww.scss"
	replace_file "alacritty.yml"
	replace_file "cava.config"

	chmod +x "$HOME/.config/theme/files/shell.sh"

	create_config_symlinks

	reload_all
}

main "$@"
