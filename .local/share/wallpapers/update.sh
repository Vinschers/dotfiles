#!/bin/sh

update_img() {
    theme="$(cat "$HOME/.local/share/wallpapers/current")"

    if [ -f "$HOME/.local/share/wallpapers/$theme" ]; then
        img="$(cat "$HOME/.local/share/wallpapers/$theme")"
    else
        img="1"
    fi

    img_path="$(/bin/ls "$HOME/.local/share/wallpapers/$theme-imgs" -1 | sed -n "${img}p")"
    [ -z "$img_path" ] && img="1" && img_path="$(/bin/ls "$HOME/.local/share/wallpapers/$theme-imgs" -1 | sed -n 1p)"

    ln -sf "$HOME/.local/share/wallpapers/$theme-imgs/$img_path" "$HOME/.local/share/wallpapers/img"

    img=$((img + 1))
    echo "$img" > "$HOME/.local/share/wallpapers/$theme"
}

if [ -n "$1" ]; then
    [ "$1" -eq 1 ] && echo "tokyonight" > "$HOME/.local/share/wallpapers/current"
fi

update_img

swww img "$HOME/.local/share/wallpapers/img" \
    --transition-bezier .4,1,1,.4 \
    --transition-type grow \
    --transition-duration 1 \
    --transition-fps 75
