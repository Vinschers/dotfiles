#!/bin/sh

update_theme() {
	ln -snf "$HOME/.config/spicetify/themes/$1" "$HOME"/.config/spicetify/Themes/default
}

if [ -n "$1" ]; then
	[ "$1" -eq 1 ] && update_theme "tokyonight"
fi

spicetify config color_scheme "default" -q
[ -d "$HOME/.config/spicetify/Backup" ] || spicetify backup -q
if pgrep spotify >/dev/null; then
	spicetify -s watch -q &
	sleep 1 && pkill spicetify
fi
