#!/bin/sh

xrandr --output HDMI-0 --primary
xrandr --setprovideroutputsource modesetting NVIDIA-0
xrandr --auto
