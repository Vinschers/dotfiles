#!/bin/sh

case "$1" in
1) theme="tokyonight" ;;
esac

[ -z "$theme" ] && exit 1

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

mkdir -p "$HOME/.config/gtk-4.0"
sed -i "$HOME/.config/gtk-4.0/settings.ini" \
	-e "s/gtk-theme-name=.*/gtk-theme-name=\"$theme\"/g" \
	-e "s/gtk-icon-theme-name=.*/gtk-icon-theme-name=\"$theme\"/g" \
	-e "s/gtk-cursor-theme-name=.*/gtk-cursor-theme-name=\"$theme\"/g"

nwg-look -a
