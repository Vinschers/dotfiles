#!/bin/sh

git config --global alias.reset-hard '!f() { git reset --hard; git clean -df ; }; f'

[ -d "$HOME/.config/dotfiles/.dotfiles-git" ] || exit 0

cd "$HOME/.config/shell/environment" && git --git-dir="$HOME/.config/dotfiles/.dotfiles-git" --work-tree="$HOME" update-index --assume-unchanged local.sh
