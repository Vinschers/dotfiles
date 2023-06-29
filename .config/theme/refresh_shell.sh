#!/bin/sh

get_theme() {
	theme="$(cat "$HOME/.config/theme/current" 2>/dev/null)"

	if [ -z "$theme" ]; then
		theme="$(/bin/ls "$HOME/.config/theme/themes/" | head -1)"
	elif [ -n "$1" ]; then
		if [ "$1" = "n" ]; then
			theme="$(/bin/ls -1 "$HOME/.config/theme/themes" | grep -A1 "$theme" | grep -v "$theme")"
			[ -z "$theme" ] && theme="$(/bin/ls -1 "$HOME/.config/theme/themes" | head -1)"
		elif [ "$1" = "p" ]; then
			theme="$(/bin/ls -1 "$HOME/.config/theme/themes" | grep -B1 "$theme" | grep -v "$theme")"
			[ -z "$theme" ] && theme="$(/bin/ls -1 "$HOME/.config/theme/themes" | tail -1)"
		fi
	fi

	echo "$theme" >"$HOME/.config/theme/current"
	"$HOME/.config/theme/update_wallpaper.sh"
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
}

get_theme ""
read_variables

printf "\033]10;#%s\007" "$fg" >/dev/tty
printf "\033]11;#%s\007" "$bg" >/dev/tty

printf "\033]4;%d;#%s\007" "0" "$color0" >/dev/tty
printf "\033]4;%d;#%s\007" "1" "$color1" >/dev/tty
printf "\033]4;%d;#%s\007" "2" "$color2" >/dev/tty
printf "\033]4;%d;#%s\007" "3" "$color3" >/dev/tty
printf "\033]4;%d;#%s\007" "4" "$color4" >/dev/tty
printf "\033]4;%d;#%s\007" "5" "$color5" >/dev/tty
printf "\033]4;%d;#%s\007" "6" "$color6" >/dev/tty
printf "\033]4;%d;#%s\007" "7" "$color7" >/dev/tty

printf "\033]4;%d;#%s\007" "8" "$color8" >/dev/tty
printf "\033]4;%d;#%s\007" "9" "$color9" >/dev/tty
printf "\033]4;%d;#%s\007" "10" "$color10" >/dev/tty
printf "\033]4;%d;#%s\007" "11" "$color11" >/dev/tty
printf "\033]4;%d;#%s\007" "12" "$color12" >/dev/tty
printf "\033]4;%d;#%s\007" "13" "$color13" >/dev/tty
printf "\033]4;%d;#%s\007" "14" "$color14" >/dev/tty
printf "\033]4;%d;#%s\007" "15" "$color15" >/dev/tty
