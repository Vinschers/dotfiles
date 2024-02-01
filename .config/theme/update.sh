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

wallpaper="$(jq -r '.wallpaper' <"$HOME/.config/theme/theme.json" | sed "s|~|$HOME|g")"

D=$(convert "$wallpaper" -format "%[fx:w<h?w:h]" info:)
convert "$wallpaper" -gravity center -crop "${D}x${D}+0+0" +repage "$HOME/.config/fastfetch/wallpaper" &
rm -rf "$HOME/.cache/fastfetch"

swww img "$wallpaper" \
	--transition-bezier .5,.4,.5,1 \
	--transition-type grow \
	--transition-duration 1 \
	--transition-fps 75 &

ss -a | grep nvim | awk '{print $5}' | while read -r nvim_socket; do
	nvim --server "$nvim_socket" --remote-send ":Lazy reload LazyVim<cr>"
done

gsettings set org.gnome.desktop.interface gtk-theme wal

hyprctl reload

wal_steam -w
