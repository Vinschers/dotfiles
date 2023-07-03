#!/bin/sh

# if ! [ -d "$HOME/.config/dotfiles/.dotfiles-git" ]; then
# 	mkdir -p "$HOME/.config/dotfiles"
# 	git clone --bare https://github.com/Vinschers/dotfiles.git "$HOME/.config/dotfiles/.dotfiles-git"
# 	git --git-dir="$HOME/.config/dotfiles/.dotfiles-git/" --work-tree="$HOME" checkout 2>&1 | grep -E "\s+\." | awk '{print $1}' | xargs -I{} rm "$HOME/{}"
# 	git --git-dir="$HOME/.config/dotfiles/.dotfiles-git/" --work-tree="$HOME" checkout
# 	git --git-dir="$HOME/.config/dotfiles/.dotfiles-git/" --work-tree="$HOME" config --local status.showUntrackedFiles no
#
# 	git --git-dir="$HOME/.config/dotfiles/.dotfiles-git" --work-tree="$HOME" update-index --assume-unchanged "$HOME/.config/shell/environment/local.sh"
# fi

curl -sSL https://raw.githubusercontent.com/Vinschers/dotfiles/master/.config/shell/environment/xdg.sh >"$HOME/.cache/xdg.sh" && . "$HOME/.cache/xdg.sh" && rm -f "$HOME/.cache/xdg.sh"

# sudo pacman --noconfirm --needed -S ansible-core ansible
# ansible-galaxy collection install -r "$HOME/.config/setup/requirements.yml"

ansible-playbook --ask-become-pass "$HOME/.config/setup/bootstrap.yml"

# yay --noconfirm --cleanafter --needed -S vscode-langservers-extracted
