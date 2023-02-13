#!/bin/sh

current_mon="$(cat "/tmp/hypr/$HYPRLAND_INSTANCE_SIGNATURE/active_monitor")"
ws="$(( current_mon + 1 ))$1"
hyprctl dispatch workspace "$ws"
