#!/bin/sh

json="$(hyprctl -j monitors)"
current_mon="$(echo "$json" | jq '.[]? | select(.focused == true) | .id')"
[ -z "$current_mon" ] && exit 0

num_monitors="$(echo "$json" | jq 'length')"

[ "$1" = "0" ] && monitor_id="$((current_mon - 1))"
[ "$1" = "1" ] && monitor_id="$(((current_mon + 1) % num_monitors))"

[ "$monitor_id" -lt 0 ] && monitor_id="$((num_monitors - 1))"

focusedws="$(echo "$json" | jq -r ".[] | select(.id == $monitor_id) | .activeWorkspace.id")"
hyprctl dispatch movetoworkspace "$focusedws"
