#!/bin/sh


set_ws() {
    id="$1"
    monitor="$2"

    hyprctl keyword workspace "$id,monitor:$monitor"
}

m=0
hyprctl monitors -j | jaq -r '.[].name' | while read -r monitor; do
    i=$((10 * m + 1))

    while [ $i -le $(( 10 * (m + 1) )) ]; do
        set_ws "$i" "$monitor" &
        i=$((i + 1))
    done
    
    m=$((m + 1))
done

dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
/usr/lib/polkit-kde-authentication-agent-1 &

"$HOME"/.config/eww/startup.sh &
"$HOME"/.config/theme/switch_theme.sh &
