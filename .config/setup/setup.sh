#!/bin/sh

curl -sSL https://raw.githubusercontent.com/Vinschers/dotfiles/master/.config/shell/environment/xdg.sh >"$HOME/.cache/xdg.sh" && . "$HOME/.cache/xdg.sh" && rm -f "$HOME/.cache/xdg.sh"

sudo pacman --noconfirm --needed -S ansible-core ansible

mkdir -p "$HOME/.config/setup"
[ -f "$HOME/.config/setup/requirements.yml" ] || curl -sSL https://raw.githubusercontent.com/Vinschers/dotfiles/master/.config/setup/requirements.yml >"$HOME/.config/setup/requirements.yml"
[ -f "$HOME/.config/setup/bootstrap.yml" ] || curl -sSL https://raw.githubusercontent.com/Vinschers/dotfiles/master/.config/setup/bootstrap.yml >"$HOME/.config/setup/bootstrap.yml"

ansible-galaxy collection install -r "$HOME/.config/setup/requirements.yml"
ansible-playbook --ask-become-pass "$HOME/.config/setup/bootstrap.yml"
