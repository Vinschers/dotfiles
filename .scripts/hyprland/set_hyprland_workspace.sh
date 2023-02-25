#!/bin/sh

ws="$1"

if [ "$(hyprctl monitors | grep -c "Monitor")" -gt 1 ]; then
	current_mon="$(hyprctl -j monitors | jaq '.[]? | select(.focused == true) | .id')"
	[ -n "$current_mon" ] && ws="$((current_mon + 1))$(printf "%s" "$ws" | tail -c 1)"
fi

hyprctl dispatch workspace "$ws"
