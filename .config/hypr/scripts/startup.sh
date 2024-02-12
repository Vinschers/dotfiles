#!/bin/sh

i=$(hyprctl monitors -j | jq length)

while [ "$i" -gt 0 ]; do
	current_ws="$(hyprctl activeworkspace -j | jq -r '.id')"
	[ "$current_ws" -gt 10 ] && current_ws="${current_ws#?}"

	hyprsome workspace 1

	hyprctl dispatch focusmonitor +1

	i=$((i - 1))
done

hyprctl dispatch exec ags
