#!/bin/sh

eww daemon || eww reload

i="$(hyprctl monitors -j | jq length)"
while [ "$i" -ge 0 ]; do
	i=$((i - 1))
    eww open "bar_window$i"
done
