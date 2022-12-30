#!/bin/sh

sudo cp -r "$HOME/.config/lightdm" /etc/
cp "$HOME/.config/lightdm/icon.png" "$HOME/.face"
[ -d /usr/share/backgrounds ] && sudo rm -rf /usr/share/backgrounds/*
sudo cp "$HOME"/.config/loginscreen.* /usr/share/backgrounds/

sudo chmod 701 "$HOME"
