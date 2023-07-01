#!/bin/sh

sudo mkdir -p /mnt/android/
sudo mkdir -p /mnt/hdd/
sudo mkdir -p /mnt/usb/

mkdir -p "$HOME/Downloads"

[ -d "$HOME/.config/librewolf" ] && ln -fs "$HOME/.config/librewolf" "$HOME/.librewolf"

if [ -d "$HOME/.config/sddm" ]; then
    sudo cp "$HOME/.config/sddm/sddm.conf" /etc/sddm.conf
	sudo cp "$HOME/.config/sddm/icon.png" "/usr/share/sddm/faces/$USER.face.icon"
fi
