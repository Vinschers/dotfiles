#!/bin/sh

[ -z "$1" ] && exit 0

window="$1"
closer="closer_$window"

monitor="$(hyprctl -j monitors | jq '.[]? | select(.focused == true) | .id')"

eww open --screen "$monitor" --toggle "$closer"
eww open --screen "$monitor" --toggle "$window"
