#!/bin/sh

create_symlink() {
	src="$HOME/.config/theme/themes/$theme/configs/$1"
	dest="$HOME/.config/$2"

	[ -e "$src" ] || return

    mkdir -p "$(dirname "$dest")"
	ln -fns "$src" "$dest"
}

copy_gtk_files() {
    [ -d "$HOME/.local/share/themes/$theme" ] || cp -r "$HOME/.config/theme/themes/$theme/configs/gtk/theme" "$HOME/.local/share/themes/$theme"
    [ -d "$HOME/.local/share/icons/$theme" ] || cp -r "$HOME/.config/theme/themes/$theme/configs/gtk/icons" "$HOME/.local/share/icons/$theme"
}

update_gtk() {
    copy_gtk_files

	sed -i "$HOME/.local/share/nwg-look/gsettings" \
		-e "s/gtk-theme=.*/gtk-theme=$theme/g" \
		-e "s/icon-theme=.*/icon-theme=$theme/g" \
		-e "s/cursor-theme=.*/cursor-theme=$theme/g"

	sed -i "$HOME/.config/gtk-2.0/gtkrc" \
		-e "s/gtk-theme-name=.*/gtk-theme-name=\"$theme\"/g" \
		-e "s/gtk-icon-theme-name=.*/gtk-icon-theme-name=\"$theme\"/g" \
		-e "s/gtk-cursor-theme-name=.*/gtk-cursor-theme-name=\"$theme\"/g"

	sed -i "$HOME/.config/gtk-3.0/settings.ini" \
		-e "s/gtk-theme-name=.*/gtk-theme-name=\"$theme\"/g" \
		-e "s/gtk-icon-theme-name=.*/gtk-icon-theme-name=\"$theme\"/g" \
		-e "s/gtk-cursor-theme-name=.*/gtk-cursor-theme-name=\"$theme\"/g"
}

change_files() {
	create_symlink "cava" "cava/config"
	create_symlink "change_theme.sh" "shell/change_theme.sh"
	create_symlink "dunst" "dunst/theme"
	create_symlink "eww.scss" "eww/css/_colors.scss"
	create_symlink "foot.conf" "foot/theme.conf"
	create_symlink "nvim.lua" "nvim/lua/utils/colorscheme.lua"
	create_symlink "wlogout.css" "wlogout/style.css"
	create_symlink "wofi.css" "wofi/style.css"
	create_symlink "zathura" "zathura/theme"
	create_symlink "bat.tmTheme" "bat/themes/theme.tmTheme"
	create_symlink "btop.theme" "btop/themes/btop.theme"
	create_symlink "spicetify" "spicetify/Themes/default"

    update_gtk
}

reload_nvim() {
	ss -a | grep nvim | awk '{print $5}' | while read -r nvim_socket; do
        nvim --server "$nvim_socket" --remote-send ":lua package.loaded['utils.colorscheme'] = nil; vim.cmd.colorscheme(require('utils.colorscheme').theme)<cr>"
	done
}

reload_spotify() {
	spicetify config color_scheme "default" -q
	[ -d "$HOME/.config/spicetify/Backup" ] || spicetify backup -q
	if pgrep spotify >/dev/null; then
		spicetify -s watch -q &
		sleep 1 && pkill spicetify
	fi
}

reload_dunst() {
	pkill dunst && hyprctl dispatch exec "cat $HOME/.config/dunst/dunstrc $HOME/.config/dunst/theme | dunst -conf -" >/dev/null
}

reload_zsh() {
	killall -s USR1 zsh 2>/dev/null
}

reload_eww() {
    eww reload >/dev/null
}

reload_cava() {
	killall -s USR1 cava 2>/dev/null
}

reload_gtk() {
    nwg-look -a >/dev/null 2>/dev/null
}

reload_bat() {
    bat cache --build >/dev/null
}

reload_all() {
	"$HOME/.config/theme/update_wallpaper.sh"

    reload_zsh
    reload_eww
    reload_gtk
    reload_nvim
    reload_dunst
    reload_cava
    reload_spotify
    reload_bat
}

main() {
	theme="$(cat "$HOME/.config/theme/current" 2>/dev/null)"

	change_files
	reload_all

    notify-send "$theme"
}

main
