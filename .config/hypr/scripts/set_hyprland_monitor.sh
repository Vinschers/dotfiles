#!/bin/sh

json="$(hyprctl -j monitors)"
current_mon="$(echo "$json" | jq '.[]? | select(.focused == true) | .id')"
[ -z "$current_mon" ] && exit 0

num_monitors="$(echo "$json" | jq 'length')"

opt="$1"
[ -z "$opt" ] && opt=0

[ "$opt" = "0" ] && monitor_id=$((current_mon - 1))
[ "$opt" = "1" ] && monitor_id=$(((current_mon + 1) % num_monitors))

[ "$monitor_id" -lt 0 ] && monitor_id=$((num_monitors - 1))

focusedws="$(echo "$json" | jq ".[] | select(.id == $monitor_id) | .activeWorkspace.id")"
hyprctl dispatch movetoworkspace "$focusedws"
