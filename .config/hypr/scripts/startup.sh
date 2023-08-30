#!/bin/sh

dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
/usr/lib/polkit-kde-authentication-agent-1 &

if ! [ -d "$HOME/.local/share/hyprload" ]; then
    curl -sSL https://raw.githubusercontent.com/Duckonaut/hyprload/main/install.sh | bash
    "$HOME"/.local/share/hyprload/hyprload.sh &
    hyprctl dispatch hyprload update
else
    "$HOME"/.local/share/hyprload/hyprload.sh &
fi

pgrep eww >/dev/null && eww kill
eww daemon

num_monitors="$(hyprctl monitors | grep -c Monitor)"

for monitor in $(seq "$(( num_monitors - 1 ))" -1 0); do
    eww open "bar_window$monitor"
done

"$HOME"/.config/theme/switch_theme.sh &
