#!/bin/sh

if ! [ -d "$HOME/.config/.dotfiles-git" ]; then
	git clone --bare https://github.com/Vinschers/dotfiles.git "$HOME/.config/.dotfiles-git"

	git --git-dir="$HOME/.config/.dotfiles-git/" --work-tree="$HOME" checkout 2>&1 | grep -E "\s+\." | awk '{print $1}' | xargs -I{} rm "$HOME/{}"
	git --git-dir="$HOME/.config/.dotfiles-git/" --work-tree="$HOME" checkout

	git --git-dir="$HOME/.config/.dotfiles-git/" --work-tree="$HOME" config --local status.showUntrackedFiles no
	git --git-dir="$HOME/.config/.dotfiles-git/" --work-tree="$HOME" update-index --assume-unchanged "$HOME/.config/shell/environment/local.sh"
	git --git-dir="$HOME/.config/.dotfiles-git/" --work-tree="$HOME" update-index --assume-unchanged "$HOME/.config/octave/octaverc"
fi

. "$HOME/.config/shell/environment/xdg.sh"

sudo pacman --noconfirm --needed -S ansible-core ansible

ansible-galaxy collection install -r "$HOME/.config/setup/requirements.yml"
ansible-playbook --ask-become-pass "$HOME/.config/setup/bootstrap.yml"

[ "$(find "$ZDOTDIR"/plugins/* -maxdepth 0 -type d | wc -l)" -eq 1 ] && /bin/zsh

rm -rf "$HOME/.ansible"
