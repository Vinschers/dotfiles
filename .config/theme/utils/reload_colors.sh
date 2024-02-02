#!/bin/sh

killall -s USR1 cava

spicetify config color_scheme "default" -q
[ -d "$HOME/.config/spicetify/Backup" ] || spicetify backup -q
if pgrep spotify >/dev/null; then
	spicetify -s watch -q &
	sleep 1 && pkill spicetify
fi

themes_dir="$HOME/.local/share/themes"
oomox_colors="$HOME/.config/oomox/oomox-colors"
/opt/oomox/plugins/theme_oomox/change_color.sh --target-dir "$themes_dir" --output wal "$oomox_colors"
gsettings set org.gnome.desktop.interface gtk-theme ''

ss -a | grep nvim | awk '{print $5}' | while read -r nvim_socket; do
	nvim --server "$nvim_socket" --remote-send "<esc>:Lazy reload LazyVim<cr>"
done

ags --run-js "scss();"

gsettings set org.gnome.desktop.interface gtk-theme wal

hyprctl reload

wal_steam -w
