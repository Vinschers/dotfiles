#!/bin/sh

current_shader="$(hyprctl getoption decoration:screen_shader -j | jq -r '.str')"
if [ "$1" = "true" ] || [ "${current_shader#*nightlight}" = "$current_shader" ]; then
    hyprctl keyword decoration:screen_shader "$HOME/.config/hypr/shaders/nightlight.frag"
else
    hyprctl keyword decoration:screen_shader "$HOME/.config/hypr/shaders/nothing.frag"
fi
