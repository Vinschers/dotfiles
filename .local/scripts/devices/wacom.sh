#!/bin/sh

sleep 1

sys_type="$(cat /sys/class/dmi/id/chassis_type)"

if [ "$sys_type" -eq 3 ] # Desktop
then
    xsetwacom --set "Wacom One by Wacom S Pen stylus" MapToOutput HEAD-0
    xsetwacom --set "Wacom One by Wacom S Pen eraser" MapToOutput HEAD-0
fi

xsetwacom --set "Wacom One by Wacom S Pen stylus" Area 0 0 11400 7125
xsetwacom --set "Wacom One by Wacom S Pen eraser" Area 0 0 11400 7125

notify-send "Wacom tablet connected"
