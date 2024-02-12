#!/bin/sh

theme="$(basename "$(readlink -f "$HOME/.config/theme/theme.json")")"

themes_dir="$HOME/.local/share/themes"
icons_dir="$HOME/.local/share/icons/$theme"
oomox_colors="$HOME/.config/oomox/oomox-colors"

[ -d "$themes_dir/$theme" ] || /opt/oomox/plugins/theme_oomox/change_color.sh --target-dir "$themes_dir" --output "$theme" "$oomox_colors"
[ -d "$icons_dir" ] || /opt/oomox/plugins/icons_archdroid/archdroid-icon-theme/change_color.sh --destdir "$icons_dir" --output "$theme" "$oomox_colors"

killall -s USR1 cava

spicetify config color_scheme Pywal -q
[ -d "$HOME/.config/spicetify/Backup" ] || spicetify backup -q
if pgrep spotify >/dev/null; then
	spicetify -s watch -q &
	sleep 1 && pkill spicetify
fi

pywalfox update

gsettings set org.gnome.desktop.interface gtk-theme "$theme"

wal_steam -w

editor_pid=$(pgrep "${EDITOR:-nvim}")
for pid in $editor_pid; do
	kill -28 "$pid"
    echo "$pid"
done

hyprctl reload
