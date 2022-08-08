#!/bin/sh

THIS_DIRECTORY="$1"
sys_type="$(cat /sys/class/dmi/id/chassis_type)"

SRC=""

if [ "$sys_type" -eq 3 ] # Desktop
then
    SRC="$THIS_DIRECTORY/xorg_config/desktop"
elif [ "$sys_type" -eq 10 ] # Notebook
then
    SRC="$THIS_DIRECTORY/xorg_config/notebook"
fi

sudo cp -r "$SRC/xorg.conf.d" /etc/X11/
