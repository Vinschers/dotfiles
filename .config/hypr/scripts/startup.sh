#!/bin/sh

hyprctl dispatch focusmonitor 0

i=$(hyprctl monitors -j | jq length)

while [ "$i" -gt 0 ]; do
	hyprctl dispatch exec hyprsome workspace 1
	hyprctl dispatch focusmonitor +1

	i=$((i - 1))
done

hyprctl dispatch focusmonitor 0
