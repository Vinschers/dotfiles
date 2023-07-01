#!/bin/sh

. "$HOME/.profile"
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

"$setup_dir/scripts/filesystem.sh"
"$setup_dir/scripts/packages.sh"
"$setup_dir/scripts/network.sh"
"$setup_dir/scripts/programs.sh"
"$setup_dir/scripts/nvidia.sh"
"$setup_dir/scripts/zsh.sh"
"$setup_dir/scripts/git.sh"

check "Setup SSD trim?" 1 && sudo systemctl enable fstrim.timer fstrim.service

/bin/zsh
