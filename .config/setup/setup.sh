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
	makepkg -si
	cd ..
	rm -rf yay/
fi

setup_dir="$(dirname "$0")"

check() {
	if [ "$2" = "1" ]; then
		printf "%s [Y/n] " "$1" >&2
		read -r ans

		[ "$ans" = "" ] || [ "$ans" = "Y" ] || [ "$ans" = "y" ]
	else
		printf "%s [y/N] " "$1" >&2
		read -r ans

		! [ "$ans" = "" ] && ! [ "$ans" = "N" ] && ! [ "$ans" = "n" ]
	fi
}

"$setup_dir/scripts/packages.sh" "$setup_dir"
"$setup_dir/scripts/network.sh"
"$setup_dir/scripts/programs.sh" "$setup_dir"
"$setup_dir/scripts/filesystem.sh"
"$setup_dir/scripts/nvidia.sh"
"$setup_dir/scripts/zsh.sh"
"$setup_dir/scripts/git.sh"

check "Setup SSD trim?" 1 && sudo systemctl enable fstrim.timer fstrim.service

/bin/zsh
