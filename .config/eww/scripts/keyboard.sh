#!/bin/sh

socat -u "UNIX-CONNECT:/tmp/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock" - | while read -r line; do
    layout="${line#activelayout\>\>}"
    if [ "$layout" != "$line" ]; then
        hyprctl devices -j | jaq -r '.keyboards[] | .active_keymap' | head -n1 | cut -c1-2 | tr '[:lower:]' '[:upper:]'
    fi
done
