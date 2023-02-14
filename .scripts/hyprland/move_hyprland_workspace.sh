#!/bin/sh

ws="$1"
current_mon="$(cat "/tmp/hypr/$HYPRLAND_INSTANCE_SIGNATURE/active_monitor")"

[ -n "$current_mon" ] && ws="$(( current_mon + 1 ))$ws"

hyprctl dispatch movetoworkspace "$ws"
