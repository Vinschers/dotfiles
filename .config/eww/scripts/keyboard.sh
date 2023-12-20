#!/bin/sh

aux=""

hyprctl devices -j | jaq -r '.keyboards[] | .active_keymap' | while read -r keyboard; do
    if [ -z "$aux" ]; then
        aux="$keyboard"
    else
        if [ "$aux" != "$keyboard" ]; then
            echo "$keyboard"
            break
        fi
    fi
done | cut -c1-2 | tr '[:lower:]' '[:upper:]'
