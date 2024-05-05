#!/bin/sh

clone_git() {
	[ -d "$HOME/.config/.dotfiles-git" ] && return

	git clone --bare --recursive https://github.com/Vinschers/dotfiles.git "$HOME/.config/.dotfiles-git"

	git --git-dir="$HOME/.config/.dotfiles-git/" --work-tree="$HOME" checkout 2>&1 | grep -E "\s+\." | awk '{print $1}' | xargs -I{} rm "$HOME/{}"
	git --git-dir="$HOME/.config/.dotfiles-git/" --work-tree="$HOME" checkout

	git --git-dir="$HOME/.config/.dotfiles-git/" --work-tree="$HOME" config --local status.showUntrackedFiles no
	git --git-dir="$HOME/.config/.dotfiles-git/" --work-tree="$HOME" update-index --assume-unchanged "$HOME/.config/shell/environment/local.sh"
	git --git-dir="$HOME/.config/.dotfiles-git/" --work-tree="$HOME" update-index --assume-unchanged "$HOME/.librewolf/profiles.ini"
	git --git-dir="$HOME/.config/.dotfiles-git/" --work-tree="$HOME" update-index --assume-unchanged "$HOME/.config/octave/octaverc"
}

run_ansible() {
	ansible-galaxy collection install -r "$HOME/.config/setup/requirements.yml"
	ansible-playbook --ask-become-pass "$HOME/.config/setup/bootstrap.yml"
}

cleanup() {
	rm -rf "$HOME/.ansible"
}

distro="$(awk '/^ID=/' /etc/*-release | awk -F'=' '{ print tolower($2) }')"

case "$distro" in
arch)
	sudo pacman --noconfirm --needed -S git ansible-core ansible
	;;
gentoo)
    sudo emerge dev-vcs/git app-admin/ansible
    ;;
*)
	exit 1
	;;
esac

clone_git
run_ansible
cleanup
[ "$(find "$HOME/.config/zsh/plugins"/* -maxdepth 0 -type d | wc -l)" -eq 1 ] && /bin/zsh
