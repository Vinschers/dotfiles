#!/bin/sh

if ! [ -d "$HOME/.config/dotfiles/.dotfiles-git" ]; then
	mkdir -p "$HOME/.config/dotfiles"
	git clone --bare https://github.com/Vinschers/dotfiles.git "$HOME/.config/dotfiles/.dotfiles-git"
	git --git-dir="$HOME/.config/dotfiles/.dotfiles-git/" --work-tree="$HOME" checkout 2>&1 | grep -E "\s+\." | awk '{print $1}' | xargs -I{} rm "$HOME/{}"
	git --git-dir="$HOME/.config/dotfiles/.dotfiles-git/" --work-tree="$HOME" checkout
	git --git-dir="$HOME/.config/dotfiles/.dotfiles-git/" --work-tree="$HOME" config --local status.showUntrackedFiles no

	git --git-dir="$HOME/.config/dotfiles/.dotfiles-git" --work-tree="$HOME" update-index --assume-unchanged "$HOME/.config/shell/environment/local.sh"
fi

. "$HOME/.config/shell/environment/xdg.sh"

sudo pacman --noconfirm --needed -S ansible-core ansible
ansible-galaxy collection install -r "$HOME/.config/setup/requirements.yml"

export NVIDIA=0
lspci -k | grep -A 2 -E "(VGA|3D)" | grep -qi nvidia && NVIDIA=1

ansible-playbook --ask-become-pass "$HOME/.config/setup/bootstrap.yml"

yay --noconfirm --cleanafter --needed -S vscode-langservers-extracted

printf "Setup SSD trim? [Y/n] "
read -r ssd

if [ "$ssd" = "" ] || [ "$ssd" = "Y" ] || [ "$ssd" = "y" ]; then
	sudo systemctl enable fstrim.timer fstrim.service
fi
