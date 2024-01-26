#!/bin/sh

update_img() {
    theme="$(cat "$HOME/.local/share/wallpapers/current")"

    if [ -f "$HOME/.local/share/wallpapers/$theme" ]; then
        img="$(cat "$HOME/.local/share/wallpapers/$theme")"
    else
        img="1"
    fi

    total="$(/bin/ls "$HOME/.local/share/wallpapers/$theme-imgs" -1 | wc -l)"
    if [ "$1" = "-1" ]; then
        img=$((img - 1))
        [ "$img" -eq 0 ] && img="$total"
    else
        img=$((img + 1))
        [ "$img" -gt "$total" ] && img="1"
    fi

    img_path="$(/bin/ls "$HOME/.local/share/wallpapers/$theme-imgs" -1 | sed -n "${img}p")"
    [ -z "$img_path" ] && img="1" && img_path="$(/bin/ls "$HOME/.local/share/wallpapers/$theme-imgs" -1 | sed -n 1p)"

    ln -sf "$HOME/.local/share/wallpapers/$theme-imgs/$img_path" "$HOME/.config/wallpaper"

    echo "$img" > "$HOME/.local/share/wallpapers/$theme"
}

if [ -n "$1" ]; then
    [ "$1" -eq 1 ] && echo "tokyonight" > "$HOME/.local/share/wallpapers/current"
fi

rm -rf "$HOME/.cache/fastfetch"

update_img "$1"

D=$(convert "$HOME/.config/wallpaper" -format "%[fx:w<h?w:h]" info:)
convert "$HOME/.config/wallpaper" -gravity center -crop "${D}x${D}+0+0" +repage "$HOME/.config/fastfetch/wallpaper" &

swww img "$HOME/.config/wallpaper" \
    --transition-bezier .5,.4,.5,1 \
    --transition-type grow \
    --transition-duration 1 \
    --transition-fps 75 &
