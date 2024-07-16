#!/bin/sh

dotfiles() {
    git --git-dir="$HOME/.config/.dotfiles-git/" --work-tree="$HOME" "$@"
}

clone_git() {
	[ -d "$HOME/.config/.dotfiles-git" ] && rm -rf "$HOME/.config/.dotfiles-git"

	git clone --bare --recursive https://github.com/Vinschers/dotfiles.git "$HOME/.config/.dotfiles-git"
    dotfiles reset --hard

    dotfiles config --local status.showUntrackedFiles no
	dotfiles update-index --assume-unchanged "$HOME/.config/shell/environment/local.sh"
	dotfiles update-index --assume-unchanged "$HOME/.config/octave/octaverc"

    dotfiles submodule update --init
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
