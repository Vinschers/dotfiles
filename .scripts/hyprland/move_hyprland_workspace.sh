#!/bin/sh

ws="$1"
current_mon="$(cat "/tmp/hypr/$HYPRLAND_INSTANCE_SIGNATURE/active_monitor")"

[ -n "$current_mon" ] && ws="$(( current_mon + 1 ))$(printf "%s" "$ws" | tail -c 1)"

hyprctl dispatch movetoworkspace "$ws"
