#!/bin/sh


sudo pacman -S --needed - < arch_packages.txt

amixer sset Master unmute
pulseaudio --check
pulseaudio -D

echo "Please, reboot your system."
