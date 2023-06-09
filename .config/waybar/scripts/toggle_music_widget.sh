#!/bin/sh

window="music"
closer="closer_$window"

current_mon="$(hyprctl -j monitors | jq '.[]? | select(.focused == true) | .id')"
window="${window}_$(( current_mon + 1 ))"
closer="${closer}_$(( current_mon + 1 ))"

eww open --toggle "$closer"
eww open --toggle "$window"
