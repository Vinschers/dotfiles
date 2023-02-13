#!/bin/sh

current_mon="$(cat "/tmp/hypr/$HYPRLAND_INSTANCE_SIGNATURE/active_monitor")"
num_monitors="$(hyprctl monitors | grep -c "Monitor")"

[ "$1" = "0" ] && monitor_id="$((current_mon - 1))"
[ "$1" = "1" ] && monitor_id="$(((current_mon + 1) % num_monitors))"

[ "$monitor_id" -lt 0 ] && monitor_id="$((num_monitors - 1))"

notify-send "$current_mon --> $monitor_id"

focusedws="$(hyprctl -j monitors | jaq -r ".[] | select(.id == $monitor_id) | .activeWorkspace.id")"
hyprctl dispatch movetoworkspace "$focusedws"
