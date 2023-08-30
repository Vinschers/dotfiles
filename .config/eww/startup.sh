#!/bin/sh

pgrep eww >/dev/null && eww kill
eww daemon

num_monitors="$(hyprctl monitors | grep -c Monitor)"

for monitor in $(seq "$(( num_monitors - 1 ))" -1 0); do
    eww open "bar_window$monitor"
done
