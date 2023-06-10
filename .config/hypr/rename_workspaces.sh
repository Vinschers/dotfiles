#!/bin/sh

handle() {
    line="$1"

    if [ "${line##*createworkspace}" != "$line" ]; then
        created_ws="$(echo "$line" | grep -oP '[0-9]+')"
        name="$(( created_ws % 10 ))"
        [ "$name" = "0" ] && name="10"

        hyprctl dispatch renameworkspace "$created_ws" "$name"
    fi
}

socat - "UNIX-CONNECT:/tmp/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock" | while read -r line; do handle "$line"; done
