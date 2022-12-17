#!/bin/sh

[ "$(xrandr | grep -csw 'connected')" -gt 1 ] && xrandr --output HDMI-0 --primary
xrandr --setprovideroutputsource modesetting NVIDIA-0
xrandr --auto
