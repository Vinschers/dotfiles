#!/bin/sh

window="music"
closer="closer_$window"

monitor="$(hyprctl -j monitors | jq '.[]? | select(.focused == true) | .id')"

eww open --screen "$monitor" --toggle "$closer"
eww open --screen "$monitor" --toggle "$window"
