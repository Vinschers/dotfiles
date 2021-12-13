#!/bin/sh

echo "oi" > ~/oi.txt
xautolock -time $LOCK_TIME -locker slock &
xrandr --output DP-1 --left-of HDMI-0 &
picom -f &
#run_nitrogen &
nitrogen --restore &
dwmblocks &
