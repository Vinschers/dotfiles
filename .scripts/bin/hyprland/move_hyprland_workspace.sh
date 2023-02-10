#!/bin/sh

current_mon="$(cat "/tmp/hypr/$HYPRLAND_INSTANCE_SIGNATURE/active_monitor")"
hyprctl dispatch movetoworkspace "$(( current_mon + 1 ))$1"
