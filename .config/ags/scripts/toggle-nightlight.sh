#!/bin/sh

current_shader="$(hyprctl getoption decoration:screen_shader -j | jaq -r '.str')"

case "$current_shader" in
    *nothing.frag)
        shader="$HOME/.config/hypr/shaders/nightlight.frag"
        ;;
    *)
        shader="$HOME/.config/hypr/shaders/nothing.frag"
        ;;
esac

hyprctl keyword decoration:screen_shader "$shader"
