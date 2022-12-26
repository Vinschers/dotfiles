#!/bin/sh

sudo cp -r "$HOME/.config/lightdm" /etc/
sudo cp "$HOME/.config/lightdm/icon.png" "/var/lib/AccountsService/icons/$(whoami).png"
sudo rm /usr/share/backgrounds/*
sudo cp "$HOME"/.config/loginscreen.* /usr/share/backgrounds/

sudo [ -f "/var/lib/AccountsService/users/$(whoami)" ] && sudo sed -i "/Icon=/c\Icon=/var/lib/AccountsService/icons/$(whoami).png" "/var/lib/AccountsService/users/$(whoami)"
