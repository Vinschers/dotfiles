#!/bin/sh

current_shader="$(hyprctl getoption decoration:screen_shader -j | jq -r '.str')"

[ -z "$current_shader" ] && current_shader="nothing.frag"

case "$current_shader" in
    *nothing.frag)
        shader="$HOME/.config/hypr/shaders/nightlight.frag"
        ;;
    *)
        shader="$HOME/.config/hypr/shaders/nothing.frag"
        ;;
esac

hyprctl keyword decoration:screen_shader "$shader"
