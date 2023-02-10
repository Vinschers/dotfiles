#!/bin/sh

current_workspace="$(hyprctl activewindow | grep -oP '(?<=workspace: )[0-9]+')"
num_monitors="$(hyprctl monitors | grep -c "Monitor")"

[ "$1" = "0" ] && workspace="$(( current_workspace - 10 ))"
[ "$1" = "1" ] && workspace="$(( (current_workspace + 10) % (10 * (num_monitors + 1)) ))"

[ -z "$workspace" ] && exit 0

[ "$1" = "0" ] && [ "$workspace" -lt 10 ] && workspace="$(( workspace + 10 * num_monitors ))"
[ "$1" = "1" ] && [ "$workspace" -lt 10 ] && workspace="$(( workspace + 10 ))"

hyprctl dispatch movetoworkspace "$workspace"
