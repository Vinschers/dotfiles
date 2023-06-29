#!/bin/sh

window="music"
closer="closer_$window"

current_mon="$(hyprctl -j monitors | jq '.[]? | select(.focused == true) | .id')"
monitor=$(( current_mon + 1 ))

eww open --screen "$monitor" --toggle "$closer"
eww open --screen "$monitor" --toggle "$window"
