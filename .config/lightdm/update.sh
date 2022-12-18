#!/bin/sh

sudo cp -r "$HOME/.config/lightdm" /etc/
sudo cp "$HOME/.config/lightdm/icon.png" "/var/lib/AccountsService/icons/$(whoami).png"
sudo cp -r "$HOME/.config/lightdm/backgrounds" /usr/share/

sudo sed -i "/Icon=/c\Icon=/var/lib/AccountsService/icons/$(whoami).png" "/var/lib/AccountsService/users/$(whoami)"