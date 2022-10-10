#!/bin/sh

sleep 1

DEFAULT_X="$(xsetwacom --get "Wacom One by Wacom S Pen stylus" Area | cut -d " " -f 3)"
DEFAULT_Y="$(xsetwacom --get "Wacom One by Wacom S Pen eraser" Area | cut -d " " -f 4)"

sys_type="$(cat /sys/class/dmi/id/chassis_type)"

if [ "$sys_type" -eq 3 ] # Desktop
then
    xsetwacom --set "Wacom One by Wacom S Pen stylus" MapToOutput HEAD-0
    xsetwacom --set "Wacom One by Wacom S Pen eraser" MapToOutput HEAD-0
fi


set_ratio_default () {
    RATIO_X=2
    RATIO_Y=2
}

set_ratio_osu () {
    RATIO_X=4
    RATIO_Y=4
}

set_area () {
    pgrep -f "osu" > /dev/null && set_ratio_osu || set_ratio_default

    xsetwacom --set "Wacom One by Wacom S Pen stylus" Area 0 0 $(( DEFAULT_X / RATIO_X )) $(( DEFAULT_Y / RATIO_Y ))
    xsetwacom --set "Wacom One by Wacom S Pen eraser" Area 0 0 $(( DEFAULT_X / RATIO_X )) $(( DEFAULT_Y / RATIO_Y ))
}

notify-send "Wacom tablet connected"

while [ "$(xsetwacom list devices | wc -l)" -gt 0 ]
do
    set_area

    [ "$(xsetwacom list devices | wc -l)" -eq 0 ] && pkill wacom.sh

    sleep 5
done

pkill wacom.sh
