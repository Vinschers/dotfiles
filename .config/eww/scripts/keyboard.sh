#!/bin/sh

echo "English"

socat -u "UNIX-CONNECT:/tmp/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock" - | while read -r line; do
    layout="${line#activelayout\>\>}"
    if [ "$layout" != "$line" ]; then
        layout="${layout##*,}"
        echo "${layout%% *}"
    fi
done
