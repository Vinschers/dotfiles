#!/bin/sh

ws="$1"
current_mon="$(hyprctl -j monitors | jaq '.[]? | select(.focused == true) | .id')"

[ -n "$current_mon" ] && ws="$(( current_mon + 1 ))$(printf "%s" "$ws" | tail -c 1)"

hyprctl dispatch workspace "$ws"
