#!/bin/sh

if ! [ -d "$HOME/.config/dotfiles/.dotfiles-git" ]; then
	mkdir -p "$HOME/.config/dotfiles"
	git clone --bare https://github.com/Vinschers/dotfiles.git "$HOME/.config/dotfiles/.dotfiles-git"
	git --git-dir="$HOME/.config/dotfiles/.dotfiles-git/" --work-tree="$HOME" checkout 2>&1 | grep -E "\s+\." | awk '{print $1}' | xargs -I{} rm "$HOME/{}"
	git --git-dir="$HOME/.config/dotfiles/.dotfiles-git/" --work-tree="$HOME" checkout
	git --git-dir="$HOME/.config/dotfiles/.dotfiles-git/" --work-tree="$HOME" config --local status.showUntrackedFiles no
fi

if ! command -v yay >/dev/null; then
	git clone https://aur.archlinux.org/yay.git
	cd yay/ || exit 1
	makepkg -si --noconfirm
	cd ..
	rm -rf yay/
fi

"$HOME/.config/setup/scripts/packages.sh"
"$HOME/.config/setup/scripts/network.sh"
"$HOME/.config/setup/scripts/programs.sh"
"$HOME/.config/setup/scripts/filesystem.sh"
"$HOME/.config/setup/scripts/nvidia.sh"
"$HOME/.config/setup/scripts/zsh.sh"
"$HOME/.config/setup/scripts/git.sh"

printf "Setup SSD trim? [Y/n] "
read -r ssd

if [ "$ssd" = "" ] || [ "$ssd" = "Y" ] || [ "$ssd" = "y" ]; then
	sudo systemctl enable fstrim.timer fstrim.service
fi

/bin/zsh
